<?php 

include_once "AppController.php";
   


if ($_POST == null) { return; }

if(isset($_POST["add_selection_id"]) || isset($_POST["edit_selection_id"]) ) {
    $id = $_POST["add_selection_id"];
    if(isset($_POST["edit_selection_id"])) {
       $id = $_POST["edit_selection_id"];
    }


    if($id == 1) {
       
    }
    else if($id == 2) {
        addFactoryIfNotExists($_POST);
        echo "<script>window.location = 'index.php'</script>";
    }
    else if($id == 3) {
        addImalathaneIfNotExists($_POST);
        echo "<script>window.location = 'index.php'</script>";
    }
    else if($id == 4) {
        
    }
    else if($id == 5) {
        addKategoriIfNotExists($_POST);
        echo "<script>window.location = 'index.php'</script>";
    }
}


function addFactoryIfNotExists($post) {
    //var_dump($_POST);
    $controller = new AppController();
    //var_dump($post);
    // array(5) { ["add_selection_id"]=> string(1) "2" ["factory_name"]=> string(15) "kaşlsdkşalkds" ["factory_address"]=> string(33) "lkasdşaksdksşdlksşldkşalksşd" ["city"]=> string(1) "1" ["ilce"]=> string(1) "1" }
    if(!isset($post["city"]) || $post["city"] == -1) { return; }
    if(!isset($post["ilce"]) || $post["ilce"] == -1) { return; }
    $address_text = "".$post["factory_address"]."";
    $factory_name = "".$post["factory_name"]."";
    if(isset($post["element_id"])) {
        echo "Update";
        var_dump($post);
       $element_id = $post["element_id"];
       $controller->updateFactory($element_id , $factory_name , $address_text, intval($post["city"]) , intval($post["ilce"]));
    }
    else {
       $controller->callProcedure("CALL public.add_factory(?,?,?,?)" , Array($post["factory_name"],$post["city"],$post["ilce"] , $post["factory_address"]));
    }
    
}

function addImalathaneIfNotExists($post) {
    
    $controller = new AppController();
    if(validateText($_POST["imalathane_name"]) == false) { return; }
    
    $imalathaneName = $_POST["imalathane_name"];  
    if(isset($post["element_id"])) { 
        $controller->updateImalathane($post["element_id"],$imalathaneName);
    }
    else {
        $controller->callProcedure("CALL public.add_imalathane(?)" , Array($imalathaneName));
    }
     
}

function addKategoriIfNotExists($post) {
    $controller = new AppController();
    if(validateText($_POST["kategori_name"]) == false) { return; }
    $kategoriName = $_POST["kategori_name"];  
    if(isset($post["element_id"])) { 
        $controller->update_kategori($post["element_id"],$kategoriName);
    }
    else {
        $controller->add_kategori(Array($kategoriName));
    }
}

function validateText($str) {
    if($str == NULL) { return false; }
    return strlen($str) > 0; 
}

?>