<!DOCTYPE html>
<html lang="en">
  <head>
      <title>Dewey 200s Optional Arrangement Conversion</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="scaffolded-by" content="https://github.com/dart-lang/sdk">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
<script defer src="dewey.js"></script>
      </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
      <div class="container-fluid">
      <a class="navbar-brand" href="#">Sample File</a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
	<span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNav">
	<ul class="navbar-nav">
	  <li class="nav-item">
	    <a class="nav-link">200s Conversion Tool <span class="sr-only">(current)</span></a>
	  </li>
	</ul>
      </div>
</div>
          </nav>
    <main>
      <div class="container">
      <h1>Dewey 200s Optional Arrangement Conversion</h1>
        <div class="row">
          <div class="col-sm-12">
            <div class="card">
               <div class="card-body">
                 <h2 class="card-title">Upload File for Call Number Conversion</h2>
		 <p><em>Note:</em> For this form to work correctly your file should be a tab-delimited text file, no larger than 1 MB, with one column titled <em>ClassificationNumber</em>.  The document can has as many other columns as you would like.  The processed document will have an additional <em>NewClassificationNumber</em> column when it is completed.</p>
                <form enctype="multipart/form-data" action="uploader-sample.php" method="POST">
		            <input type="hidden" name="MAX_FILE_SIZE" value="1000000" />
		            <div class="input-group mb-3">
		              <input type="file" id="deweyuploadfile" name="deweyuploadedfile" class="form-control">
		            </div>
		            <button class="btn btn-primary" type="submit">Upload File</button>
	            </form>
              <?php
                if (isset($_REQUEST['dataset']) AND ($_REQUEST['dataset'] == 1)) {
                  echo "<br><div class=\"alert alert-success\" role=\"alert\">Data Uploaded</div>";
                }
              ?>
            </div>
          </div> 
        </div>
      </div>
 
  </main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
  </body>
</html>
