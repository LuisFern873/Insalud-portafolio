import pandas as pd
import fitz
import os
import numpy as np
from scipy.stats import multivariate_normal
import locale

locale.setlocale(locale.LC_TIME, "es_ES")

diagnostico_map = {
    'Cistitis Cronica': 'cistitis',
    'Disfunción erectil': 'disfuncion',
    'Micosis Genital B49.0': 'micosis',
    'Prostatitis cronica N41.1': 'protatitis',
    'VPH A63.0': 'verrugas'
}

firma_map = {
    'Antonio': 'data/antonio_firma.png',
    'Fiorella': 'data/fiorella_firma.png'
}

def reemplazar_placeholders(doc, nombre, fecha_str):
    for page in doc:
        for original, nuevo in {"PACIENTE": nombre, "DD de MM de YYYY": fecha_str}.items():
            for rect in page.search_for(original):
                page.add_redact_annot(rect)
                page.apply_redactions(images=0)
                fontsize = rect.height * 0.8
                page.insert_text((rect.x0, rect.y0), nuevo, fontname="helv",
                                 fontsize=fontsize, color=(0, 0, 0))

def posicion_aleatoria_gaussiana(xmin, xmax, ymin, ymax, m=10, n=5, sigma=(30,20)):
    xs = np.linspace(xmin, xmax, n)
    ys = np.linspace(ymin, ymax, m)
    X, Y = np.meshgrid(xs, ys)
    mu = [(xmin+xmax)/2, (ymin+ymax)/2]
    rv = multivariate_normal(mean=mu, cov=[[sigma[0]**2, 0],[0, sigma[1]**2]])
    probs = rv.pdf(np.dstack((X, Y)))
    probs /= probs.sum()
    idx = np.unravel_index(np.random.choice(m*n, p=probs.ravel()), (m, n))
    return float(X[idx]), float(Y[idx])

def insertar_firma(doc, firma_path, pos, ancho=100, alto=50):
    pix = fitz.Pixmap(firma_path)
    if not pix.alpha:
        pix = fitz.Pixmap(pix, 1)
    rect = fitz.Rect(pos[0], pos[1], pos[0] + ancho, pos[1] + alto)
    for page in doc:
        page.insert_image(rect, pixmap=pix, overlay=True)

def generar_recetas_from_excel(excel_path, plantillas_dir, salida_dir='salida'):

    df = pd.read_excel(
        excel_path,
        sheet_name='Registros',
        dtype={'Nro. Doc. Usuario': str}
    )

    for _, row in df.iterrows():
        emisor = row['Emisor'].strip().lower()
        fecha_obj = pd.to_datetime(row['Fecha de Atención'])
        fecha_str = fecha_obj.strftime("%d de %B de %Y")
        dni = str(row['Nro. Doc. Usuario'])
        print("dni:", dni)
        paciente = row['Apellidos y Nombres, Denominación o Razón Social del Usuario']
        diag = row['Diagnostico']


        clave = next((diagnostico_map[k] for k in diagnostico_map if k in str(diag)), None)
        if not clave:
            print(f"⚠️ Diagnóstico no reconocido: {diag}")
            continue

        plantilla = os.path.join(plantillas_dir, row['Emisor'], f"receta_{clave}.pdf")
        if not os.path.exists(plantilla):
            print(f"⚠️ Plantilla no encontrada: {plantilla}")
            continue

        doc = fitz.open(plantilla)
        reemplazar_placeholders(doc, paciente, fecha_str)

        firma_file = firma_map.get(row['Emisor'])
        if firma_file and os.path.exists(firma_file):
            xmin, xmax, ymin, ymax = 150, 350, 550, 750
            x_sel, y_sel = posicion_aleatoria_gaussiana(xmin, xmax, ymin, ymax)
            insertar_firma(doc, firma_file, (x_sel, y_sel))
        else:
            print(f"⚠️ Firma no encontrada para {row['Emisor']}")

        emisor_dir = os.path.join(salida_dir, emisor)
        os.makedirs(emisor_dir, exist_ok=True)

        output_name = f"Receta_{dni}_{fecha_obj.strftime('%d-%m-%Y')}.pdf"

        # emisor_dir = "recetas\\fiorella_corregido"

        output_path = os.path.join(emisor_dir, output_name)
        doc.save(output_path)
        doc.close()
        print(f"✅ Generada: {output_path}")

if __name__ == '__main__':
    generar_recetas_from_excel('data/data.xlsx', 'plantillas')
