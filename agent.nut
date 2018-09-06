#require "Rocky.class.nut:2.0.1"

// CONSTANTS
const HTML_STRING = @"<!DOCTYPE html><html lang='en-US'><meta charset='UTF-8'>
<html>
  <head>
    <title>What the Founter</title>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <style>

    </style>
  </head>
  <body>
    <div class='header'></div>
    <div class='count'>0</div>
    
    
    <script>
        var agenturl = '%s';
        
        
        function getCount(callback) {
            const xhr = new XMLHttpRequest();
            xhr.open('GET', `${agenturl}/count`, true);
            xhr.onload = function(res){
                console.log(this);
                const response = JSON.parse(this.response);
                const count_field = document.querySelector('.count');
                count_field.textContent = response.what_the_fu_count;
            }
            xhr.send(null);
        }
        document.addEventListener('DOMContentLoaded', function(event) { 
            getCount();
        });
    </script>
  </body>
</html>";

// GLOBALS
api <- null;
savedData <- null;


// FUNCTIONS
function increase_count(data) {
    // Save the data
    savedData.what_the_fu_count = savedData.what_the_fu_count + 1;

    local result = server.save(savedData);
}

// START OF PROGRAM

api = Rocky();

// Set up the app's API
api.get("/", function(context) {
  // Root request: just return standard HTML string
  local url = http.agenturl();
  context.send(200, format(HTML_STRING, url));
});

api.get("/count", function(context) {
  // Request for data from /state endpoint
  context.send(200, { "what_the_fu_count" : savedData.what_the_fu_count});
});

// Set up the backup data
savedData = {};
savedData.what_the_fu_count <- 0;


local backup = server.load();
if (backup.len() != 0) {
  savedData = backup;
} else {
  local result = server.save(savedData);
  if (result != 0) server.error("Could not back up data");
}

// Register the function to handle data messages from the device
device.on("fu_crease", increase_count);