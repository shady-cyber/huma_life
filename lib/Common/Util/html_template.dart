class HtmlTemplate {
  static String htmlCode = """
      <!DOCTYPE html>
  <html>
  <head>
  <style>
      .container {
  width: 100%;
  height: 100%;
  display: flex;
  gap: 1px;
  margin-top: 30px;
  flex-direction: row;
  flex-wrap: wrap;
}

    .card {
box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
flex: 0 0 30%;
border: 1px solid #000000;
border-radius: 20px;
text-align: justify-all;
margin: auto auto 10px;
}


button {
border: none;
outline: 0;
display: inline-block;
padding-top: 8vh;
color: white;
background-color: #151f31;
text-align: center;
cursor: pointer;
width: 100%;
font-size: 18px;
}

a {
text-decoration: none;
font-size: 22px;
color: black;
}

.data-section {
width: 50%;
height: 100%;
margin-left: 33%;
text-align: left;
padding-top: 10px;
}

.data-section p {
overflow-wrap: break-word;
font-size: 10px;
}

.img-section img {
width: 60px;
height: 60px;
border-radius: 50%;
position: absolute;
top: 10%;
left: 0;
margin: 10px 10px 0 5px;
}

.row {
display: block;
border-bottom: 1px solid #ccc;
}


.img-section {
position: relative;
float: left;
width: 30%;
height: 100%;
text-align: center;
margin-right: 5px;
padding: 10px;
}

.qr-section {
position: relative;
width: 100%;
height: 100%;
text-align: center;
padding-top: 4px;
}

.qr-section img {
width: 160px;
height: 160px;
padding: 2px;
}

.footer {
position: relative;
left: 0;
bottom: 0;
width: 100%;
height: 70px;
border-bottom-left-radius: 20px;
border-bottom-right-radius: 20px;
background-color: #151f31;
color: #ffffff;
text-align: center;
}

.footer p {
padding-top: 10px;
line-height: 1.5;
}

.line-break {
page-break-after: always;
}

</style>
</head>
<body>
<div class="container">
""";
}
