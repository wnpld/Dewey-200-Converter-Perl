<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Uploading File...</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
      <div class="container-fluid">
      <a class="navbar-brand" href="#">Uploader Sample</a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
	<span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNav">
	<ul class="navbar-nav">
	  <li class="nav-item">
	    <a class="nav-link" href="deweyconvert.php">200's Conversion Tool</a>
	  </li>
	</ul>
      </div>
</div>
          </nav>
    <main role="main">
      <div class="container">
	<?php
          // Where the file is going to be placed
      if (isset($_FILES['deweyuploadedfile'])) {
          $target_path = "/var/tmp/200sfile.txt";
          $file = $_FILES['deweyuploadedfile']['tmp_name'];
          
          if(move_uploaded_file($file, $target_path)) {
 
		?><!-- "" -->
	<div class="pb-5 mb-4 bg-light rounded-3">
	  <div class="container-fluid py-4">			     
	    <h1 class="display-5 fw-bold">Dewey File Upload Successful</h1>
	    <p class="lead">Your file has been uploaded.  Click "Continue" to process it.  You will be informed if there are any problems processing your file.</p>
	  </div>
	</div>
	<div class="container">
	  <form id="AddWdForm" name="AddWdForm" method="post" action="/cgi-bin/dewey_remap.pl">
	    <div class="row mt-3">
		<button type="submit" class="btn btn-primary btn-lg btn-block">Continue...</button>
	    </div>
	  </form>
<?php
	} else {
   ?>
<h1>File Processing Error</h1>
   <div class="alert alert-warning">The file was unable to be uploaded. Contact IT if you do not know why this happened or what this means. <?php echo $file ?></div>
<?php
	}
          } else {
   ?>
<h1>File Processing Error</h1>
              <div class="alert alert-warning">No file was submitted.  Please submit a file.</div>

<?php
          }
   ?>
	</div>
      </div>
    </main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
