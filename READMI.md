# HackerBooks

##Descripcion: 
Aplicacion para ipad que permite cargar una lista de libros, ver el detalle de cada uno de ellos y leer el pdf del mismo.

##Tabla: 
Se muestran todos los libros en una tabla que permite ordenarlos por diferentes maneras, orden alfabetico y tags. Este controlador de tipo TableViewController esta metido dentro de un ViewController para poder meter los dos botones que controlaran en ordenadado que se ha implementado mediante un segmented control.

##Modelo: 
Se tiene tiene como modelo un libro que contiene todos los datos necesarios del mismo y del cual se muestran los datos en un controlador BookViewController.

##Pdf: 
Por cada libro se tiene un controlador PdfViewController que mostrara el contenido del pdf de cada libro. en caso de que el usuario en la tabla cambiara de libro se avisa a traves del delegado a este viewController de que el libro ha cambiado y se actualiza el pdf mostrado conforme a la seleccion del usuario en la tabla.


Cada libro tambien se puede marcar como favorito, en este caso se guarda en la libreria una variable de tipo Set<string> que impide que haya elementos repetidos. A su vez los favoritos se guardan en la sandbox  en un fichero con estructura titulo1#titulo2#titlo3#... de esta menera y haciendo un split por el campo # podemos identificar rapidamente los titulos de los libros añadidos a favoritos.

La informacion del favorito se envia a traves del delegado del modelo Book que detecta que un libro ha sido marcado como favorito y avisa mediante su delegado a la vista para que esta refresque los datos. En cuanto al refresco con el metodo reloadData carga todos los datos de la tabla. Esto en principio y si los datos no son muchos puede funcionar pero no seria lo mas eficiente, entiendo que lo mejor seria solamente recargar las secciones que esten visibles en ese momento.

##Notas: 
La parte visual se ha implementado para un ipad2, no dispongo de mucho conocimiento en cuanto a posicionar los elementos para distintos dispositivos de manera que he primado el funcionamiento de la aplicacion sobre la maquetacion y diseño.
