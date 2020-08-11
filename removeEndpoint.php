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
            else if ($type == 3) {
                removeImalathane($id);
                echo "<script>window.location = 'index.php'</script>";
            }
            else if($type == 4) {

            }
            else if($type == 5) {
                removeKategori($id);
                echo "<script>window.location = 'index.php'</script>";
            }
        }
    }

    function removeKategori($id) {
        $controller = new AppController();
        $controller->remove_kategori(Array($id));
    }

    function removeFactory($id) {
        $controller = new AppController();
        $controller->removeFactory($id);
    }

    function removeImalathane($id) {
        $controller = new AppController();
        $controller->remove_imalathane($id);
    }

?> 