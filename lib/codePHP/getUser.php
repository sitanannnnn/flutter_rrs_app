<?php
header("content-type:text/javascript;charset=utf8-8");
error_reporting(0);
error_reporting(E_ERROR | E_PARSE);
     $link = mysqli_connect('localhost','root','12345aomam','data_rrs');
    if(!$link){
        echo "Error : Unable to connect to MySQL." .PHP_EOL;
        echo "Debugging errno" .mysqli_connect_errno().PHP_EOL;
        echo "Debugging error" .mysqli_connect_error().PHP_EOL;
        exit;
    }
    if (!$link -> set_charset("utf8")) {
        print("error loading character set utf8 : %s\n".$link->error);
        exit();
    }
    if (isset($_GET)) {
    if($_GET['isAdd']=='true'){

    $user =$_GET['user'];
    $result = mysqli_query($link, "SELECT*FROM customer WHERE user = '$user'");
    
    if($result){
      while ($row=mysqli_fetch_assoc($result)) {
          $output[]=$row;
          # code...
      }
        echo json_encode($output);
       
    }
        }else echo "Welcome Restaurant";
    } mysqli_close($link);
   
?>