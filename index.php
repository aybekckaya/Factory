
<?php



?>

<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" >

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" ></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" ></script>
    
    


    <title>Fabrika</title>

  </head>
  <body>
  <div class="container" style='margin-top:32px;'>

   <div id="title-buttons">
   <div class="btn-group" style="margin-top:16px;">
   <button type="button" class="btn btn-primary" id="1">Kişiler</button>
   <button type="button" class="btn btn-primary" id="2">Fabrikalar</button>
   <button type="button" class="btn btn-primary" id="3">İmalathaneler</button>
   <button type="button" class="btn btn-primary" id="4">Ürünler</button>
   <button type="button" class="btn btn-primary" id="5">Kategoriler</button>
   <button type="button" class="btn btn-primary" id="6">Müdürler</button>
   <button type="button" class="btn btn-primary" id="7">Sorumlular</button>
   <button type="button" class="btn btn-primary" id="8">Personeller</button>
   <button type="button" class="btn btn-primary" id="9">Personel Yakınları</button>
   </div>
   </div>
   
   </div>
   
   

   <div id="title_field" class="col-md-12 h2 text-center" style='margin-top:16px;' >I am Title</div>
   <button type="button" class="btn btn-primary float-right" id="Add" style='margin-top:16px;'>Ekle</button>
   <div id= "table_area" class="col-md-offset-2" style='margin-top:16px;' >
   
   
   </div>

  

  
  </body>


  <script type="text/javascript">
        var selected_type = 2;
        

       $('document').ready(function(){
          sendRequest(selected_type);
       });

       $('button').click(function(){
            
           if (this.id != "Add" && this.id < 100) { selected_type = this.id; }
            sendRequest(this.id);
            


        });

        function sendRequest(id) {
            $.post( "Endpoint.php",{type:"type_button_select" , user_info: {"id": id}}, function( data ) {
                var jsonDecoded = jQuery.parseJSON(data);
                var html = jsonDecoded.html;
                $('#table_area').html(html);
                $('#title_field').html(jsonDecoded.title);
                
                if(jsonDecoded.navigate_to_add_form == true) {
                    location.href = 'add.php?selected='+selected_type;
                }
                
            });
        }

     </script>

</html>


<?php 








/*
 
$host='localhost';
$db = 'Factory';
$username = 'postgres';
$password = '1020304050Aa';

$dsn = "pgsql:host=$host;port=5432;dbname=$db;user=$username;password=$password";
 
try{
 // create a PostgreSQL database connection
 $conn = new PDO($dsn);
 
 // display a message if connected to the PostgreSQL successfully
 if($conn){
 echo "Connected to the <strong>$db</strong> database successfully!";
 }
}catch (PDOException $e){
 // report error message
 echo $e->getMessage();
}

//$ss = $conn->prepare('CALL samplesc.insertproduct(?,?)');
//$ss->execute(array('yarrak' , 123123));

$ss = $conn->prepare('CALL samplesc.updateprod()');
$ss->execute();

// Query Data 
$sql_get_depts = "SELECT * FROM samplesc.product";
try{
    $dbh = new PDO($dsn, $username, $password);
    $stmt = $dbh->query($sql_get_depts);
    
    if($stmt === false){
      die("Error executing the query: $sql_get_depts");
    }

    while($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        var_dump($row);
    }
    
   }catch (PDOException $e){
    echo $e->getMessage();
   }

*/

/*
$db_handle = pg_connect("host=localhost dbname=WorldDB user=postgres password=1020304050Aa");

if ($db_handle) {

echo 'Connection attempt succeeded.';

} else {
var_dump($db_handle);
echo 'Connection attempt failed.';

}



$res = pg_query($db_handle, "INSERT INTO \"country\" (id, name) VALUES (213, 'Germany')");
//pg_query($db_handle, 'INSERT INTO "Country" (id, name) VALUES (3, "France")');
var_dump($res);
$res = pg_query($db_handle , "CALL samplesc.insertprice(2325)");
echo pg_errormessage($db_handle);

$query = 'SELECT * FROM "country"';

$result = pg_exec($db_handle, $query);

if ($result) {

    echo "The query executed successfully.<br>";
    
    echo "<h3>Print First and last name:</h3>";
    
    for ($row = 0; $row < pg_numrows($result); $row++) {
    
    $name = pg_result($result, $row, 'name');
    
    echo $name ." ";
    
    }
    
    } else {
    
    echo "The query failed with the following error:<br>";
    
    echo pg_errormessage($db_handle);
    
    }



pg_close($db_handle);
*/
?>