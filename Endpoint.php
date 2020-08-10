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
       if($id == 1) {
          if($subId == 103) {
            $arr["title"] = "Beşiktaş";
            $arr["html"] = '';
          }
       }
       else if($id == 2) {
           $arr["title"] = "Fabrikalar";
           $factories = $controller->get_all_factories();
           var_dump($factories);
           $html = renderFactories($factories);
           $arr["html"] = $html;
       }
       else if ($id == 3) {
           $arr["title"] = "İmalathaneler";
           $imalathane = $controller->get_all_imalathane();
           $html = renderImalathane($imalathane);
           $arr['html'] = $html;
       }
       else if ($id == "Add") {
          $arr["navigate_to_add_form"] = true;
          $arr["html"] = '';
       }
       
       
       echo json_encode($arr);
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
          $html .= '<td><a href="?type=3&action=delete&id='.$factory['id'].'">Sil</a></td>';
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
       
      $html .= '</tr>';
      $html .= '</thead>';

      $html .= '<tbody>';
      $counter = 1;
      foreach($arr_factories as $factory) {
          $html .= '<tr>';
          $html .= '<th scope="row">'.$counter.'</th>';
          $html .= '<td>'.$factory["fabrika_adi"].'</td>';
          $html .= '<td>'.$factory["text"].'</td>';
          $html .= '<td>'.$factory["sehir_adi"].'</td>';
          $html .= '<td>'.$factory["ilce_adi"].'</td>';
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
 