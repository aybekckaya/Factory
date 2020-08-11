<?php 
   include_once "AppController.php";
   $controller = new AppController();
   $all_cities = $controller->get_all_cities();
   $all_ilce = $controller->get_all_ilce();
   
   
   $is_editing = isset($_GET["type"]) ? true : false;
   
   $selected_type = 1;
   $id_selected = 1;
   $current_item = NULL;

   if($is_editing == true) {
      $id_selected = $_GET["id"];
      $selected_type = $_GET["type"];
      if($selected_type == 1) {
        
      }
      else if($selected_type == 2) {
          $current_item = $controller->get_factory($id_selected);
          //var_dump($current_item);
      }
      else if($selected_type == 3) {
           $current_item = $controller->get_imalathane($id_selected);
          // var_dump($current_item);
      }
      else if($selected_type == 4) {

      }
      else if($selected_type == 5) {
        $current_item = $controller->get_kategori($id_selected);
      }
   }
   else {
     $selected_type = $_GET["selected"] == NULL ? 1 : $_GET["selected"];
   }
   

   function getTitle($selected_type , $is_editing) {
      if($selected_type == 1) {
         return $is_editing == true ? "Kişi Değiştirme" : "Kişi Ekleme";
      }
      else if($selected_type == 2) {
        return $is_editing == true ? "Fabrika Değiştirme" : "Fabrika Ekleme";
      }
      else if($selected_type == 3) {
        return $is_editing == true ? "İmalathane Değiştirme" : "İmalathane Ekleme";
      }
      else if($selected_type == 4) {
        return $is_editing == true ? "Ürün Değiştirme" : "Ürün Ekleme";
      }
      else if($selected_type == 5) {
        return $is_editing == true ? "Kategori Değiştirme" : "Kategori Ekleme";
      }
      
      return "asdasd";
   }


?>


<!DOCTYPE html>
<html lang="en">
<head>
  <title>Ekleme</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>

<a href = "index.php">Anasayfa</a>
<div class="container">
  <h2><?php 
     
     echo getTitle($selected_type , $is_editing);
     
  ?></h2>

  


  <?php 
     if ($selected_type == 2 ) { 
  ?>
  <form action="editEndpoint.php" method = post>
  <?php 
    if($is_editing == true ) {
      echo '<input type="hidden" id="edit_selection_id" name="edit_selection_id" value="2">';
      echo '<input type="hidden" id="element_id" name="element_id" value="'.$current_item["id"].'">';
    }
    else {
      echo '<input type="hidden" id="add_selection_id" name="add_selection_id" value="2">';
    }
  
  ?>
  
    <div class="form-group">
      <label>Fabrika Adı:</label>
      <?php 
      if($is_editing == true ) {
        echo '<input type="text" class="form-control" id="factory_name" placeholder="Fabrika Adı" name="factory_name" value="'.$current_item["fabrika_adi"].'">';
      }
      else {
        echo '<input type="text" class="form-control" id="factory_name" placeholder="Fabrika Adı" name="factory_name">';
      }
      
      ?>
      
    </div>

    <div class="form-group">
      <label>Adres:</label>
      
      <?php 
      if($is_editing == true ) {
        echo '<input type="text" class="form-control" id="address" placeholder="Adres" name="factory_address" value="'.$current_item["text"].'">';
      }
      else {
        echo '<input type="text" class="form-control" id="address" placeholder="Adres" name="factory_address">';
      }
      
      ?>
    </div>

    <div class="form-group">
    <label for="sel1">Şehir</label>
      <select class="form-control" id="city" name="city">
      <?php 
       echo '<option value = -1>Seçiniz</option>';
        foreach($all_cities as $city) {
            echo '<option value ='.$city['id'].'>'.$city["sehir_adi"].'</option>';
        }
      ?>
      </select>
      </div>

      <div class="form-group">
    <label for="sel1">İlçe</label>
      <select class="form-control" id="ilce" name="ilce">
      <?php 
       echo '<option value = -1>Seçiniz</option>';
        foreach($all_ilce as $city) {
            echo '<option value ='.$city['id'].'>'.$city["ilce_adi"].'</option>';
        }
      ?>
      </select>
      </div>
    
    <button type="submit" class="btn btn-primary">Submit</button>
  </form>

  <?php 
     }
  ?>
  












  <?php 
     if ($selected_type == 3 ) { 
  ?>
  <form action="editEndpoint.php" method = post>
  <?php 
    if($is_editing == true ) {
      echo '<input type="hidden" id="edit_selection_id" name="edit_selection_id" value="3">';
      echo '<input type="hidden" id="element_id" name="element_id" value="'.$current_item["id"].'">';
    }
    else {
      echo '<input type="hidden" id="add_selection_id" name="add_selection_id" value="3">';
    }
  
  ?>
  
    <div class="form-group">
      <label>İmalathane Adı:</label>
      <?php 
      if($is_editing == true ) {
        
        echo '<input type="text" class="form-control" id="imalathane_adi" placeholder="İmalathane Adı" name="imalathane_name" value="'.$current_item["imalathane_adi"].'">';
      }
      else {
        echo '<input type="text" class="form-control" id="imalathane_adi" placeholder="İmalathane Adı" name="imalathane_name">';
      }
      
      ?>
      
    </div>
    
    <button type="submit" class="btn btn-primary">Submit</button>
  </form>

  <?php 
     }
  ?>
  














  <?php 
     if ($selected_type == 5 ) { 
  ?>
  <form action="editEndpoint.php" method = post>
  <?php 
    if($is_editing == true ) {
      echo '<input type="hidden" id="edit_selection_id" name="edit_selection_id" value="5">';
      echo '<input type="hidden" id="element_id" name="element_id" value="'.$current_item["id"].'">';
    }
    else {
      echo '<input type="hidden" id="add_selection_id" name="add_selection_id" value="5">';
    }
  
  ?>
  
    <div class="form-group">
      <label>Kategori Adı:</label>
      <?php 
      if($is_editing == true ) {
        
        echo '<input type="text" class="form-control" id="kategori_adi" placeholder="Kategori Adı" name="kategori_name" value="'.$current_item["imalathane_adi"].'">';
      }
      else {
        echo '<input type="text" class="form-control" id="kategori_adi" placeholder="Kategori Adı" name="kategori_name">';
      }
      
      ?>
      
    </div>
    
    <button type="submit" class="btn btn-primary">Submit</button>
  </form>

  <?php 
     }
  ?>
  











</div>

</body>
</html>
