# Portfolio · Fabrizio Barrial

Mi portfolio profesional como estudiante de ASIR: un solo `index.html` con Tailwind CSS (CDN), Lucide Icons y JavaScript propio, sin dependencias de compilación.

🌐 **En vivo:** https://TU_DOMINIO.es

## Qué tiene
- Terminal interactiva (`help`, `neofetch`, `skills`, `open <proyecto>`, `nmap fabrizio`…).
- Habilidades con medidores de nivel.
- Proyectos con vistas interactivas del resultado: log de backups en vivo, simulación de ransomware con restauración, consola de GPO, snapshot LVM, ping animado por un switch…
- Diseño adaptable y respeto a "reducir movimiento".

## Publicarlo con GitHub Pages y dominio propio
1. *Settings › Pages › Build and deployment › Deploy from a branch* → rama `main`, carpeta `/ (root)`.
2. Renombra `CNAME.ejemplo` a `CNAME` y escribe dentro tu dominio (por ejemplo `fabriziobarrial.es`).
3. En el panel DNS de tu proveedor del `.es`, crea estos registros:
   - `A` para `@` → las cuatro IP de GitHub Pages (están en la documentación oficial: *Managing a custom domain for your GitHub Pages site*).
   - `CNAME` para `www` → `fabrizio2032-svc.github.io`
4. Vuelve a *Settings › Pages*, espera a que valide el dominio y marca **Enforce HTTPS**.
5. Sube tu CV como `CV_Fabrizio_Barrial.pdf` a la raíz del repositorio para que funcione el botón de descarga.
