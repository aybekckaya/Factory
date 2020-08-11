<?php 
   include_once "AppController.php";
   
   $controller = new AppController();

   if ($_POST == null) { return; }
   $type = $_POST["type"];
   $user_info = $_POST["user_info"];
   
   if ($type == "type_button_select") {
       $arr = Array();
       $id = $user_info["id"];
       $subId = $user_info["subtype"];
       $arr["navigate_to_add_form"] = false;
       $arr["title"] = "";
       $arr["id"] = $id;
       $arr["subid"] = $subId;
       $arr["html"] = "";
       if($id == 1) {
          
       }
       else if($id == 2) {
           $arr["title"] = "Fabrikalar";
           $factories = $controller->get_all_factories();
           $html = renderFactories($factories);
           $arr["html"] = $html;
       }
       else if ($id == 3) {
           $arr["title"] = "İmalathaneler";
           $imalathane = $controller->get_all_imalathane();
           $html = renderImalathane($imalathane);
           $arr['html'] = $html;
       }
       else if($id == 4) {
           $arr["title"] = "Ürünler";
           $all_products = $controller->get_all_products();
           $html = renderProducts($all_products);
           $arr['html'] = $html;
       }
       else if($id == 5) {
         $arr["title"] = "Kategoriler";
         $arr_objects = $controller->get_all_kategori();
         $html = renderKategori($arr_objects);
         $arr['html'] = $html;

       } 
       else if ($id == "Add") {
          $arr["navigate_to_add_form"] = true;
          $arr["html"] = '';
       }
       
       
       echo json_encode($arr);
   }


   function renderProducts($arr_imalathane) {
    if(sizeof($arr_imalathane) == 0) { return ''; }
    $html = '<div class="table-responsive">';
     $html .= '<table class="table table-striped">';
     $html .= '<thead>';
     $html .= '<tr>';

     $html .= '<th scope="col">#</th>';
     $html .= '<th scope="col">Ürün Adı</th>';
      
     $html .= '</tr>';
     $html .= '</thead>';
     $html .= '<tbody>';
     $counter = 1;

     foreach($arr_imalathane as $factory) { 
       $html .= '<tr>';
         $html .= '<th scope="row">'.$counter.'</th>';
         $html .= '<td>'.$factory["urun_adi"].'</td>';
         $html .= '<td><a href="add.php?type=4&id='.$factory['id'].'">Değiştir</a></td>';
         $html .= '<td><a href="removeEndpoint.php?type=4&action=delete&id='.$factory['id'].'">Sil</a></td>';
         $html .= '</tr>';
         $counter += 1;
     }

     $html .= '</tbody>';

     $html .= '</table>';
     $html .= '</div>';
     $html .= '</div>';

     return $html;
   }

   function renderKategori($arr_imalathane) {
    if(sizeof($arr_imalathane) == 0) { return ''; }
    $html = '<div class="table-responsive">';
     $html .= '<table class="table table-striped">';
     $html .= '<thead>';
     $html .= '<tr>';

     $html .= '<th scope="col">#</th>';
     $html .= '<th scope="col">Kategori Adı</th>';
      
     $html .= '</tr>';
     $html .= '</thead>';
     $html .= '<tbody>';
     $counter = 1;

     foreach($arr_imalathane as $factory) { 
       $html .= '<tr>';
         $html .= '<th scope="row">'.$counter.'</th>';
         $html .= '<td>'.$factory["kategori_adi"].'</td>';
         $html .= '<td><a href="add.php?type=5&id='.$factory['id'].'">Değiştir</a></td>';
         $html .= '<td><a href="removeEndpoint.php?type=5&action=delete&id='.$factory['id'].'">Sil</a></td>';
         $html .= '</tr>';
         $counter += 1;
     }

     $html .= '</tbody>';

     $html .= '</table>';
     $html .= '</div>';
     $html .= '</div>';

     return $html;
   }


   function renderImalathane($arr_imalathane) {
     if(sizeof($arr_imalathane) == 0) { return ''; }
     $html = '<div class="table-responsive">';
      $html .= '<table class="table table-striped">';
      $html .= '<thead>';
      $html .= '<tr>';

      $html .= '<th scope="col">#</th>';
      $html .= '<th scope="col">İmalathane Adı</th>';
       
      $html .= '</tr>';
      $html .= '</thead>';
      $html .= '<tbody>';
      $counter = 1;

      foreach($arr_imalathane as $factory) { 
        $html .= '<tr>';
          $html .= '<th scope="row">'.$counter.'</th>';
          $html .= '<td>'.$factory["imalathane_adi"].'</td>';
          $html .= '<td><a href="add.php?type=3&id='.$factory['id'].'">Değiştir</a></td>';
          $html .= '<td><a href="removeEndpoint.php?type=3&action=delete&id='.$factory['id'].'">Sil</a></td>';
          $html .= '</tr>';
          $counter += 1;
      }

      $html .= '</tbody>';

      $html .= '</table>';
      $html .= '</div>';
      $html .= '</div>';

      return $html;

   }


   function renderFactories($arr_factories) {
      if(sizeof($arr_factories) == 0) { return ''; }
      $html = '<div class="table-responsive">';
      $html .= '<table class="table table-striped">';
      $html .= '<thead>';
      $html .= '<tr>';

      $html .= '<th scope="col">#</th>';
      $html .= '<th scope="col">Fabrika Adı</th>';
      $html .= '<th scope="col">Adres</th>';
      $html .= '<th scope="col">Şehir</th>';
      $html .= '<th scope="col">İlçe</th>';
      $html .= '<th scope="col">Genel Müdür</th>';
      $html .= '<th scope="col">İmalathane Sayısı</th>';
       
      $html .= '</tr>';
      $html .= '</thead>';

      $html .= '<tbody>';
      $counter = 1;
      foreach($arr_factories as $factory) {
          $genel_mudur_adi = $factory["ad"]." ".$factory["soyad"];
          $html .= '<tr>';
          $html .= '<th scope="row">'.$counter.'</th>';
          $html .= '<td>'.$factory["fabrika_adi"].'</td>';
          $html .= '<td>'.$factory["text"].'</td>';
          $html .= '<td>'.$factory["sehir_adi"].'</td>';
          $html .= '<td>'.$factory["ilce_adi"].'</td>';
          $html .= '<td>'.$genel_mudur_adi.'</td>';
          $html .= '<td>'.$factory["imalathane_count"].'</td>';
          $html .= '<td><a href="add.php?type=2&id='.$factory['id'].'">Değiştir</a></td>';
          $html .= '<td><a href="removeEndpoint.php?type=2&action=delete&id='.$factory['id'].'">Sil</a></td>';
          $html .= '</tr>';
          $counter += 1;
      }

      $html .= '</tbody>';

      $html .= '</table>';
      $html .= '</div>';
      $html .= '</div>';

      return $html;
   }





/**
 * 
 * 
 * <div class="table-responsive">

  <table class="table table-striped">
  <thead>
    <tr>
      <th scope="col">#</th>
      <th scope="col">First</th>
      <th scope="col">Last</th>
      <th scope="col">Handle</th>
      <th scope="col">#</th>
      <th scope="col">First</th>
      <th scope="col">Last</th>
      <th scope="col">Handle</th>
      <th scope="col">#</th>
      <th scope="col">First</th>
      <th scope="col">Last</th>
      <th scope="col">Handle</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">3</th>
      <td>Larry</td>
      <td>the Bird</td>
      <td>@twitter</td>
      <td>Mark</td>
      <td>Otto</td>
      <td>@mdo</td>
      <td>Mark</td>
      <td><a href="form.php?id=3">Değiştir</a></td>
      <td><a href="">Sil</a> </td>
    </tr>
  </tbody>
</table>


</div>
</div>
 * 
 * 
 * 
 */


?>
 