<?php 
    include_once "AppController.php";

    if($_GET != NULL) {
        if(isset($_GET["action"])) {
            $action = $_GET["action"];
            $type = $_GET["type"];
            $id = $_GET["id"];
            if($type == 1) {
    
            }
            else if($type == 2) {
               //Remove Factory 
               removeFactory($id);
               echo "<script>window.location = 'index.php'</script>";
            }
        }
    }


    function removeFactory($id) {
        $controller = new AppController();
        $controller->removeFactory($id);
    }

?> 