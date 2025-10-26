# Guía para contribuir

Este archivo contiene la guía para el equipo de trabajo sobre cómo se deben realizar cambios y actualizaciones al momento de contribuir al desarrollo de la aplicación móvil.

---

## Requisitos previos

Antes de contribuir, asegúrate de:

- Tener acceso al repositorio.
- Contar con permisos de escritura.
- Leer esta guía completa.
- Usar Visual Studio Code para contribuir.

---

## Estilo y convenciones

- **Idioma:** Toda la documentación debe estar en Español (neutro).
- **Formato de archivo:** Markdown (`.md`)
- **Estilo de redacción:**
    - Usa un lenguaje claro, técnico y sin ambigüedades.
    - Evita jerga innecesaria o coloquialismos.
    - Utiliza títulos jerárquicos (`#`, `##`, `###`) para organizar el contenido.
    - Al redactar, usa buena ortografía y gramática.
- **Sobre los commits:**
    - Usa mensajes de commit claros y descriptivos (ver sección "¿Cómo realizar commits?").

---

## ¿Cómo contribuir?

### 1. Ediciones pequeñas (corrección de errores, cambios de nombre, etc.)

- Puedes editar directamente desde GitHub si tienes acceso.
- Aunque es mejor editar directamente desde Visual Studio Code.

### 2. Nuevas secciones o cambios importantes

- Crea una nueva rama desde `develop` con el nombre: `feature/feature-name`.
- Asegúrate de seguir el estilo y la estructura definidos.
- Haz un Pull Request con una descripción clara del cambio.

---

## ¿Cómo realizar commits?

- Se usará **Convencional Commits** para mantener un historial claro.
- El mensaje de commit debe ser en **Inglés**.
- Usa el tiempo presente y un tono imperativo.
- A continuacion, se muestra el formato del mensaje de commit:
- `type(scope): description`

  Donde:
    - `type` puede ser:
        - `feat`: Nueva funcionalidad o sección (en la rama `feature/`).
        - `fix`: Corrección de errores.
        - `docs`: Cambios en la documentación.
        - `style`: Cambios de formato, espacios, etc.
        - `refactor`: Reestructuración sin cambios en el contenido.
        - `chore`: Actualizaciones de dependencias o tareas de mantenimiento.
        - `test`: Añadir o modificar pruebas.
    - `scope` es opcional y puede ser el nombre de la sección afectada.
    - `description` es un resumen conciso del cambio (máximo 50 caracteres).

### Ejemplos de mensajes de commit

- `feat(register-product): add product aggregate root`
- `fix: correct naming convention for interfaces`
- `docs(readme): update project description`
- `refactor(inventory-management): reorganize context structure`

### Reglas de los commits

- Cada commit debe tener un solo propósito.
- Evita commits demasiado grandes o con múltiples cambios.
- Revisa el mensaje del commit antes de hacerlo.
- Usa el tiempo presente y un tono imperativo.
- No se debe realizar un commit en la rama `main` ni en `develop` directamente.

---

## Revisión y aprobación

- Al realizar un cambio (commit), debe avisarse al equipo para su revisión.
- Todo cambio debe ser revisado por al menos 1 miembro del equipo antes de ser fusionado.
- Usa comentarios claros en el pull request para indicar el propósito del cambio.
- El responsable de la revisión debe asegurarse de que el cambio cumple con las normas establecidas.
- Además, de haber algún error o problema, debe ser redactado en el mensaje de aprobación o rechazo.

---