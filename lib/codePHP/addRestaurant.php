<?php
    header("content-type:text/javascript;charset=utf-8");
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
        printf("Error loading character set utf8: %s\n", $link->error);
        exit();
    }
    if (isset($_GET)) {
    if($_GET['isAdd']=='true'){ 
    $chooseType=$_GET['chooseType'];
    $name =$_GET['name'];
    $user =$_GET['user'];
    $email =$_GET['email'];
    $phonenumber =$_GET['phonenumber'];
    $password =$_GET['password'];
    $confirmpassword =$_GET['confirmpassword'];
    $restaurantPicture =$_GET['restaurantPicture'];
    $restaurantIdNumber =$_GET['restaurantIdNumber'];
    $restaurantNameshop =$_GET['restaurantNameshop'];
    $restaurantBranch=$_GET['restaurantBranch'];
    $restaurantAddress =$_GET['restaurantAddress'];
    $typeOfFood =$_GET['typeOfFood'];
  

    

  
    $sql= "INSERT INTO `restaurant` (`restaurantId`,`chooseType`,`name`,`user`,`email`,`phonenumber`,`password`,`confirmpassword`,`restaurantPicture`,`restaurantIdNumber`,`restaurantNameshop`,`restaurantBranch`,`restaurantAddress`,`typeOfFood`) 
           VALUES (null,'$chooseType','$name','$user','$email','$phonenumber','$password','$confirmpassword','$restaurantPicture','$restaurantIdNumber','$restaurantNameshop','$restaurantBranch','$restaurantAddress','$typeOfFood')";
    
    $result = mysqli_query($link,$sql);
    // $count = mysqli_num_rows($result);

    if($result){
        echo "true";
    }else{
        echo "false";
       
    }
        }else echo "Welcome Restaurant";
    } mysqli_close($link);
   
?>