# COMPROBAR CONECTOR
switch ((Test-Path "C:\Program Files (x86)\MySQL\MySQL Connector Net 8.0.28")) {
    true { "conector instalado correctamente" }
    false { exit }
    Default { "error" }
}


# añadir objectos externos
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') 
# CONEXION A BD
try {
    # UAC
    $usuario = [Microsoft.VisualBasic.Interaction]::InputBox('por favor, introduzca llave de acceso:', 'CREDENCIALES') 
    # cargo el modulo mysql.data . SI NO TENGO EL CONECTOR INSTALADO EL EL SISTEMA DA ERROR
    [void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
    # creo un objeto MySql.Data.MySqlClient.MySqlConnection
    $Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
    # defino mi cadena de conexion a la base de datos
    $ConnectionString = "server=" + "lldn292.servidoresdns.net" + ";port=3306;uid=" + "qagm394" + ";pwd=$usuario" + ";database="+"qagm291"
    # defino un parametro dentro del objeto que he creado antes, con valor: mi cadena de conexion
    $Connection.ConnectionString = $ConnectionString
    # abro la conexion 
    $Connection.Open()
    # AÑADIR WINDOWS FORMS: DISPLAY CONEXION ESTABLECIDA
    Write-Warning "CONEXION ESTABLECIDA . . . ."
    
}
catch {
    Write-Warning "ERROR IN CONNECT" 
    exit
    $false
}


# VARIABLES REQUERIDAS
# creo una variable con el contenido de un fichero
$config_close = (gc .\config.txt)
# creo una variable con el contenido de un script:
$config_close_invoker = {
    # guardar variable en fichero
    $script_setup > script.ps1
    # ejecutar fichero.
    .\script.ps1
}
function get_version() {
    (((Get-ChildItem -Path HKCU:\HKEY_CURRENT_USER\SOFTWARE\RETAMAR | Select-Object Name).Name).split("\"))[3] | Out-GridView -Title "VERSION SIGB"
}


# ver lectores ==> libro
function ver_lectores(){
    # declarar variable: cadena de texto: SQL QUERY
    $ver_lectores = '
    SELECT lectores.nombre AS "lector",lectores.telefono AS "telefono",lectores.dni AS "dni",lectores.prime AS "prime",libros.titulo AS "libro" FROM lectores inner JOIN libros ON lectores.libro=libros.id;
    '
    # declarar variable: remplazo el valor "+++" por "variable de cadena de texto SQL QUERY" de una variable
    $script_setup = ($config_close.replace("+++",'$ver_lectores'))
    # ejecutar un comando de forma especial: contenido de un script
    invoke-command $config_close_invoker
}

function ver_escritores(){
    $ver_escritores = '
    SELECT escritores.nombre AS "escritor",libros.titulo AS "libro",libros.tapa AS "tapa",editoriales.nombre AS "editorial" FROM escritores inner JOIN libros ON escritores.libro=libros.id inner JOIN editoriales ON libros.editorial=editoriales.id;
    '
    $script_setup = ($config_close.replace("+++",'$ver_escritores'))
    invoke-command $config_close_invoker
}

function ver_editoriales(){
    $ver_editoriales = '
    SELECT escritores.nombre AS "escritor",libros.titulo AS "libro",libros.tapa AS "tapa" FROM escritores inner JOIN libros ON escritores.libro=libros.id inner JOIN editoriales ON libros.editorial=editoriales.id;
    '
    $script_setup = ($config_close.replace("+++",'$ver_editoriales'))
    invoke-command $config_close_invoker  
}

function ver_libros(){
    $ver_libros = '
    SELECT libros.titulo AS "libro",escritores.nombre AS "escritor",editoriales.nombre AS "editorial" FROM libros inner JOIN escritores ON escritores.id=libros.escritor inner JOIN editoriales ON libros.editorial=editoriales.id;
    '
    $script_setup = ($config_close.replace("+++",'$ver_libros'))
    invoke-command $config_close_invoker
}

function ver_numlectores_libro(){
    $ver_numlectores_libro = '
    SELECT libros.titulo,COUNT(lectores.libro) AS "numero lectores" FROM lectores inner JOIN libros ON lectores.libro=libros.id GROUP BY libros.titulo;
    '
    $script_setup = ($config_close.replace("+++",'$ver_numlectores_libro'))
    invoke-command $config_close_invoker  
}

function ver_esc_lib_edit(){
    $ver_esc_lib_edit = '
    SELECT libros.titulo AS "libro",escritores.nombre AS "escritor",editoriales.nombre AS "editorial" FROM libros inner JOIN escritores ON libros.escritor=escritores.id inner JOIN editoriales ON libros.editorial=editoriales.id ;
    '
    $script_setup = ($config_close.replace("+++",'$ver_esc_lib_edit'))
    invoke-command $config_close_invoker  
}


function select_editoriales_adv (){
    $select_editoriales_adv = '
    select * from editoriales;
    '
    $script_setup = ($config_close.replace("+++",'$select_editoriales_adv'))
    invoke-command $config_close_invoker 
}


function update_valor{
    $tabla_modificar = [Microsoft.VisualBasic.Interaction]::InputBox('TABLA', 'NOMBRE TABLA') 
    $columna_modificar = [Microsoft.VisualBasic.Interaction]::InputBox('COLUMNA', 'NOMBRE COLUMNA') 
    $valor = [Microsoft.VisualBasic.Interaction]::InputBox('VALOR', 'VALOR')
    $id =  [Microsoft.VisualBasic.Interaction]::InputBox('ID', 'ID') 

    $update_valor = [string]"    
    UPDATE $tabla_modificar SET $columna_modificar='$valor' WHERE id=$id;
    "
    $script_setup = ($config_close.replace("+++",'$update_valor'))
    invoke-command $config_close_invoker 
}


function delete_valor{
    $tabla =  ([Microsoft.VisualBasic.Interaction]::InputBox('TABLA', 'TABLA'))
    $id = ([Microsoft.VisualBasic.Interaction]::InputBox('ID', 'ID'))
    select_editoriales_adv

    $delete_valor = [string]"
    DELETE FROM $tabla WHERE id='$id';
    "
    $script_setup = ($config_close.replace("+++",'$delete_valor'))
    invoke-command $config_close_invoker     
    select_editoriales_adv
}


Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'sigb.designer.ps1')
$SIGB.ShowDialog()