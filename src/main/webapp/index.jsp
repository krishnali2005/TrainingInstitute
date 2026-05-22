<!DOCTYPE html>
<html>
<head>
    <title>Training Institute Login</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f9; text-align: center; margin-top: 100px; }
        .box { display: inline-block; background: white; padding: 40px; border-radius: 8px; box-shadow: 0px 4px 10px rgba(0,0,0,0.1); }
        input { display: block; margin: 15px auto; padding: 10px; width: 250px; border: 1px solid #ccc; border-radius: 4px; }
        button { padding: 10px 20px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        button:hover { background-color: #218838; }
    </style>
</head>
<body>

    <div class="box">
        <h2>Institute Management System</h2>
        <h3>Login Portal</h3>
        
        <form action="LoginServlet" method="POST">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Sign In</button>
        </form>
    </div>

</body>
</html>