<?php 


class AppController {
    private $conn;
    private $dsn;
    private $username;
    private $password;

    function __construct() {
        $host='localhost';
        $db = 'Factory';
        $username = 'postgres';
        $password = '1020304050Aa';
       
        $dsn = "pgsql:host=$host;port=5432;dbname=$db;user=$username;password=$password";
        $this->dsn = $dsn;
        $this->username = $username;
        $this->password = $password;
       try{
        // create a PostgreSQL database connection
        $this->conn = new PDO($dsn);
        
        // display a message if connected to the PostgreSQL successfully
        if($this->conn){
           //echo "Connected to the <strong>$db</strong> database successfully!";
        }
       }catch (PDOException $e){
        // report error message
        //echo $e->getMessage();
       }
    }

    function __destruct() {
        //echo "Destruct";
        //$this->conn->close();
        $this->conn = null;
    }


    private function select_query($q) {
        $arr = Array();
        try{
            $dbh = new PDO($this->dsn, $this->username, $this->password);
            $stmt = $dbh->query($q);
            
            if($stmt === false){ return $arr; }
        
            while($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                //var_dump($row);
                //echo "</br>";
                $arr[] = $row;
            }
             return $arr;

           }catch (PDOException $e){
             //echo $e->getMessage();
              return $arr;
           }
    }


    private function update_query($q , $array) {
        $sql = $q;
        $this->conn->prepare($sql)->execute($array);
    }


    private function processRawTableArray($field_names , $raw_arr) {
       $arr = Array();
       foreach($raw_arr as $theArr) {
         $innerArr = Array();
         foreach($field_names as $field) {
             $innerArr[$field] = $theArr[$field];
         }
         $arr[] = $innerArr;
       }
       return $arr; 
    }

    function get_all_factories() {
        $arr_temp = $this->select_query("SELECT * 
        FROM public.fabrika f , public.adres a , public.sehir s , public.ilce i  
        WHERE a.id = f.adres_id AND s.id = a.sehir_id AND i.id = a.ilce_id ORDER BY f.id ");
        return $this->processRawTableArray(Array("id","fabrika_adi","sehir_adi","text" , "ilce_adi"), $arr_temp); 
    }

    function get_all_imalathane() {
        $arr_temp = $this->select_query("SELECT * 
        FROM public.imalathane i  ORDER BY i.id ");
        return $this->processRawTableArray(Array("id","imalathane_adi"), $arr_temp); 
    }

    function get_imalathane($id) {
        $arr_temp = $this->select_query("SELECT * 
        FROM public.imalathane i WHERE i.id = $id ORDER BY i.id ");
        return $this->processRawTableArray(Array("id","imalathane_adi"), $arr_temp)[0]; 
    }

    function get_factory($id) {
        $arr_temp = $this->select_query("SELECT * 
        FROM public.fabrika f , public.adres a , public.sehir s , public.ilce i  
        WHERE a.id = f.adres_id AND s.id = a.sehir_id AND i.id = a.ilce_id AND f.id = $id ORDER BY f.id ");
        return $this->processRawTableArray(Array("id","fabrika_adi","sehir_adi","text" ,"ilce_adi","adres_id"), $arr_temp)[0];
    }

    function get_address($id) {
        $arr_temp = $this->select_query("SELECT * 
        FROM  public.adres a  
        WHERE a.id = $id");
        return $this->processRawTableArray(Array("id","text","sehir_id", "ilce_id"), $arr_temp)[0];
    }


    function get_all_cities() {
        $arr_temp = $this->select_query("SELECT * 
        FROM public.sehir");
        return $this->processRawTableArray(Array("id","sehir_adi"), $arr_temp); 
    }

    function get_all_ilce() {
        $arr_temp = $this->select_query("SELECT * 
        FROM public.ilce");
        return $this->processRawTableArray(Array("id","ilce_adi"), $arr_temp); 
    }

    function removeFactory($id) {
        $this->callProcedure("CALL remove_factory(?)", Array($id));
    }

    function updateFactory($id , $factory_name , $address_text, $city_id , $ilce_id) {
        $current_factory = $this->get_factory($id);
        $current_address = $this->get_address($current_factory["adres_id"]);
        $q = "UPDATE public.adres SET text=? , sehir_id=?,ilce_id=?  WHERE id=?";
        $this->update_query($q , Array($address_text , $city_id , $ilce_id, $current_address["id"]));
        $q = "UPDATE public.fabrika SET fabrika_adi=? WHERE id=?";
        $this->update_query($q , Array($factory_name , $id));
        
    }


    function updateImalathane($id,$name) {
        $q = "UPDATE public.imalathane SET imalathane_adi=? WHERE id=?";
        $this->update_query($q , Array($name , $id));
    }

    function callProcedure($procedure , $array) {
        $ss = $this->conn->prepare($procedure);
        $ss->execute($array);
    }

}


$controller = new AppController();
//$arr = $controller->get_all_imalathane();
//var_dump($arr);
//$arr = $controller->get_all_factories();
//var_dump($arr);
//$controller->updateFactory(1,"Aybek Can Kaya" , "Aybek Caddesi", 1,2);

?>