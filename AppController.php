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
        $arr_temp = $this->select_query("SELECT * , f.id as id
        FROM public.fabrika f , public.adres a , 
        public.sehir s , public.ilce i , public.genel_mudur gm   
        WHERE a.id = f.adres_id AND s.id = a.sehir_id AND i.id = a.ilce_id 
        AND gm.fabrika_id = f.id
        ORDER BY f.id ");
        
        $arrProcessed = $this->processRawTableArray(Array("id","fabrika_adi","sehir_adi","text" , "ilce_adi" , "ad","soyad"), $arr_temp); 
        $arr_final = Array();
        foreach($arrProcessed as $factory) {
            $q = 'SELECT COUNT(*) as imalathane_count
            FROM fabrika_imalathane fi
            WHERE fi.fabrika_id ='.$factory["id"];
            $row = $this->select_query($q)[0];
            $factory["imalathane_count"] = $row["imalathane_count"];
            $arr_final[] = $factory;
            
        }
        
        return $arr_final;
    }

    function get_all_imalathane() {
        $arr_temp = $this->select_query("SELECT * , i.id as id  
        FROM public.imalathane i  ORDER BY i.id ");
        return $this->processRawTableArray(Array("id","imalathane_adi"), $arr_temp); 
    }

    function get_imalathane($id) {
        $arr_temp = $this->select_query("SELECT * 
        FROM public.imalathane i WHERE i.id = $id ORDER BY i.id ");
        return $this->processRawTableArray(Array("id","imalathane_adi"), $arr_temp)[0]; 
    }

    function get_factory($id) {
        $arr_temp = $this->select_query("SELECT * , f.id as id
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

    function get_all_kategori() {
        $arr_temp = $this->select_query("SELECT * 
        FROM  public.kategori");
        return $this->processRawTableArray(Array("id","kategori_adi"), $arr_temp);
    }

    function get_kategori($id) {
        $arr_temp = $this->select_query("SELECT * 
        FROM  public.kategori WHERE id = $id");
        return $this->processRawTableArray(Array("id","kategori_adi"), $arr_temp)[0];
    }

    function update_kategori($id,$kategori_adi) {
        $q = "UPDATE public.kategori SET kategori_adi=? WHERE id=$id";
        $this->update_query($q,Array($kategori_adi));
    }

    function add_kategori($arr) {
        $q = "INSERT INTO public.kategori(kategori_adi) VALUES(?)";
        $this->update_query($q , $arr);
    }

    function remove_kategori($arr) {
        $this->callProcedure("CALL remove_kategori(?)",$arr);
    }

    function get_all_products() {
        $arr_temp = $this->select_query("SELECT * 
        FROM  public.urun");
        return $this->processRawTableArray(Array("id","urun_adi"), $arr_temp);
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

    function remove_imalathane($id) {
        $this->callProcedure("CALL remove_imalathane(?)", Array($id));
    }

    function updateFactory($id , $factory_name , $address_text, $city_id , $ilce_id) {
        $current_factory = $this->get_factory($id);
        $current_address = $this->get_address($current_factory["adres_id"]);
        /*
        var_dump($id);
        var_dump($address_text);
        var_dump($factory_name);
        var_dump($city_id);
        var_dump($ilce_id);
        */
        //var_dump($current_address);
        //var_dump($current_factory);
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
//$controller->updateFactory(5,);
//$arr = $controller->get_all_imalathane();
//var_dump($arr);
//$arr = $controller->get_all_factories();
//var_dump($arr);
//$controller->updateFactory(6,"Aybek Can Kaya" , "Aybek Caddesi123", 1,2);

?>