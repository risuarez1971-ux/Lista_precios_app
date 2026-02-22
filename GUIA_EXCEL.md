# 📊 Guía para Archivos Excel de Importación

## Estructura Básica (Requerida)

Tu archivo Excel **DEBE** tener al menos estas columnas en la primera fila:

| Nombre | Precio |
|--------|--------|
| Coca Cola 2L | 150.50 |
| Pan Integral | 85.00 |
| Leche Entera 1L | 120.75 |

## Estructura Completa (Recomendada)

Para aprovechar todas las funciones, usa estas columnas:

| Nombre | Precio | Código de Barras | Cantidad | Categoría | Descripción | Precio de Compra | Proveedor |
|--------|--------|------------------|----------|-----------|-------------|------------------|-----------|
| Coca Cola 2L | 150.50 | 7790895000362 | 50 | Bebidas | Gaseosa sabor cola | 100.00 | Coca-Cola |
| Pan Integral | 85.00 | 7792700123456 | 100 | Panadería | Pan de molde integral | 55.00 | Bimbo |
| Leche Entera 1L | 120.75 | 7791234567890 | 75 | Lácteos | Leche entera fortificada | 85.00 | La Serenísima |
| Arroz Blanco 1kg | 200.00 | 7790000012345 | 30 | Despensa | Arroz largo fino | 140.00 | Molinos |
| Aceite Girasol 900ml | 350.00 | 7794000111222 | 25 | Despensa | Aceite de girasol alto oleico | 250.00 | Cocinero |

## Notas Importantes

### ✅ Columnas Requeridas
- **Nombre**: Nombre del producto (obligatorio)
- **Precio**: Precio de venta (obligatorio, usar números con punto decimal: 150.50)

### 📝 Columnas Opcionales
- **Código de Barras**: EAN-13, UPC, o cualquier código
- **Cantidad**: Stock inicial (número entero)
- **Categoría**: Clasificación del producto
- **Descripción**: Detalles adicionales
- **Precio de Compra**: Para calcular margen de ganancia
- **Proveedor**: Nombre del proveedor

### 🎯 Reglas de Formato

1. **Primera fila = Encabezados**
   - La primera fila DEBE contener los nombres de las columnas
   - No importa el orden de las columnas
   - Los nombres pueden variar: "Nombre", "Producto", "nombre", "NOMBRE", etc.

2. **Formatos de Precio**
   - ✅ Correcto: `150.50` o `150,50`
   - ✅ Correcto: `$150.50` o `$ 150.50`
   - ❌ Incorrecto: `150.50.00` o `ciento cincuenta`

3. **Códigos de Barras**
   - Solo números
   - Longitud típica: 8, 12 o 13 dígitos
   - Ejemplo: `7790895000362`

4. **Cantidades**
   - Solo números enteros
   - Sin decimales
   - Ejemplo: `50`, `100`, `25`

## Ejemplos de Archivos Válidos

### Ejemplo 1: Mínimo (Solo campos requeridos)

```
| Nombre          | Precio |
|-----------------|--------|
| Café Molido     | 450.00 |
| Azúcar 1kg      | 180.00 |
| Galletitas      | 120.00 |
```

### Ejemplo 2: Con Códigos de Barras

```
| Nombre          | Precio | Código de Barras |
|-----------------|--------|------------------|
| Café Molido     | 450.00 | 7790000111111    |
| Azúcar 1kg      | 180.00 | 7790000222222    |
| Galletitas      | 120.00 | 7790000333333    |
```

### Ejemplo 3: Completo con Inventario

```
| Producto | Precio | Código | Stock | Categoría | Precio Compra |
|----------|--------|--------|-------|-----------|---------------|
| Coca Cola 2L | 150.50 | 7790895000362 | 50 | Bebidas | 100.00 |
| Pan Integral | 85.00 | 7792700123456 | 100 | Panadería | 55.00 |
| Leche 1L | 120.75 | 7791234567890 | 75 | Lácteos | 85.00 |
```

## Variaciones Aceptadas de Nombres de Columnas

La app reconoce estos nombres (no importa mayúsculas/minúsculas):

### Para "Nombre":
- Nombre
- Producto
- nombre
- producto
- NOMBRE
- PRODUCTO

### Para "Precio":
- Precio
- Price
- Valor
- precio
- PRECIO

### Para "Código de Barras":
- Codigo
- Codigo de Barras
- Barras
- EAN
- UPC
- SKU
- codigo
- barcode

### Para "Cantidad":
- Cantidad
- Stock
- Inventario
- cantidad
- stock

### Para "Categoría":
- Categoria
- Category
- Tipo
- categoria

## Errores Comunes y Soluciones

### ❌ Error: "El archivo está vacío"
**Solución**: Asegúrate de que el archivo tenga al menos 2 filas (encabezados + 1 producto)

### ❌ Error: "No se encontraron columnas Nombre y Precio"
**Solución**: Verifica que la primera fila tenga columnas llamadas "Nombre" y "Precio"

### ❌ Error: "Precio inválido"
**Solución**: 
- Usa punto (.) como separador decimal: `150.50`
- No uses comas en miles: `1500` NO `1,500`
- Puedes incluir símbolo $: `$150.50`

### ❌ Error: "Algunos productos no se importaron"
**Solución**: Revisa que cada fila tenga:
- Nombre (no vacío)
- Precio (número mayor a 0)

## Plantilla para Descargar

Crea un archivo Excel con esta estructura y guárdalo como `plantilla_productos.xlsx`:

```
Nombre | Precio | Código de Barras | Cantidad | Categoría | Descripción | Precio de Compra | Proveedor
-------|--------|------------------|----------|-----------|-------------|------------------|----------
       |        |                  |          |           |             |                  |
```

## Consejos Útiles

1. **Usa Excel o Google Sheets** para crear el archivo
2. **Guarda como .xlsx** (Excel moderno) o .xls (Excel antiguo)
3. **Revisa los precios** antes de importar
4. **Haz una copia de seguridad** de tus datos actuales
5. **Prueba con pocos productos** primero
6. **Los códigos de barras duplicados** se reemplazarán

## Proceso de Importación Paso a Paso

1. **Preparar archivo Excel** con la estructura correcta
2. **Guardar en el dispositivo** (Descargas, Documentos, etc.)
3. **En la app**, tocar botón "Importar"
4. **Seleccionar archivo** desde el selector
5. **Esperar** mientras se importa
6. **Verificar** el mensaje de éxito con cantidad de productos

## Ejemplos Reales

### Supermercado

```
| Producto | Precio | Código | Stock | Categoría |
|----------|--------|--------|-------|-----------|
| Coca Cola 2.25L | 380.00 | 7790895623451 | 120 | Bebidas |
| Pepsi 2.25L | 360.00 | 7790742012345 | 80 | Bebidas |
| Pan Lactal | 450.00 | 7792700111111 | 50 | Panadería |
| Manteca La Serenísima | 680.00 | 7791234222222 | 40 | Lácteos |
```

### Ferretería

```
| Artículo | Precio | Stock | Categoría |
|----------|--------|-------|-----------|
| Tornillo 5x20 (x100) | 250.00 | 500 | Bulonería |
| Pintura Latex 20L | 12500.00 | 15 | Pinturas |
| Cable 2.5mm (metro) | 180.00 | 1000 | Electricidad |
```

### Kiosco

```
| Producto | Precio | Código |
|----------|--------|--------|
| Alfajor Jorgito | 120.00 | 7790580111111 |
| Caramelos Sugus | 80.00 | 7622210222222 |
| Chicles Beldent | 90.00 | 7622300333333 |
```

---

## ¿Necesitas Ayuda?

Si tienes problemas para importar tu archivo:

1. Verifica la estructura del Excel
2. Asegúrate de que tenga extensión .xlsx o .xls
3. Revisa que los precios sean números válidos
4. Comprueba que la primera fila sean encabezados

**¡Tu archivo Excel está listo para importar! 📊**
