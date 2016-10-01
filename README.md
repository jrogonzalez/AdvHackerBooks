# HackerBooks

##Descripcion: 
Aplicacion para ipad/iPhone que permite las siguientes funcionaliddades:
- Cargar una lista de libros.
- Guardarlos en BBDD.
- Ver el detalle de cada uno de ellos.
- Buscar un libro por título, autor o tags.
- Leer el pdf del mismo.
- Añadir notas a los libros.
- Posicionar las notas con geolocalizacion.

##Tabla: 
Se muestran todos los libros en una tabla que permite ordenarlos por diferentes maneras, orden alfabetico y tags. Este controlador de tipo CoreDataTableViewController esta metido dentro de un ViewController para poder meter los dos botones que controlaran en ordenadado que se ha implementado mediante un segmented control.

##Modelo: 
Se tiene como modelo un fichero sqlite y la carga de los libros de hace desde local en un fichero JSON (la aplicacion incluye un flag que permite la descarga desde remoto en vez de desde local). La busqueda se los libros se hace a traves de un fetchRequest que implementa las diferentes busquedas.

##Pdf: 
Por cada libro se tiene un controlador PdfViewController que mostrara el contenido del pdf de cada libro. en caso de que el usuario en la tabla cambiara de libro se avisa a traves del delegado a este viewController de que el libro ha cambiado y se actualiza el pdf mostrado conforme a la seleccion del usuario en la tabla.

##Favoritos:
Cada libro tambien se puede marcar como favorito, en este caso se guarda una nueva entidad bookTag con el libro y el tag favorito, cuando se elimina de favoritos se borra dicha entidad de bookTag.

##Notas:
Las notas se muestra en un CoreDataTableViewController (me queda pendiente hacerlo en el CollectionCoreDataTableViewController dado que carecemos de dicha clase en swift de momento). Las notas propiamente dichas tienen su propia celda personalizada y permiten tanto tomar una photo de la galeria como editar el texto de dicha nota. Tambien se ha implementado la funcionalidad de eliminar notas.

##TO-DO: 
La parte visual se ha implementado para un iPad/iPhone, no dispongo de mucho conocimiento en cuanto a posicionar los elementos para distintos dispositivos de manera que he primado el funcionamiento de la aplicacion sobre la maquetacion y diseño. Me queda pendiente hacer resize de diversos elementos como labels, imagenes y demas en funcion del dispositivo en que se visualicen asi como añadir constraints.
La parte Opcional no me ha dado tiempo a desarrollarla, empecé a hacer las tareas del Pdf de bajo nivel para poder mostrar la ultima pagina leida y poder navegar a ella cuando se carga el libro pero me he perdido bastante con la clase CGPDFDocument y no he sido capaz de sacarlo de momento.
