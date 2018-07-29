$(document).ready(function()
{
  $('button').on('click', function()
  {
    // Specify if playing X or O.
    let name = $(this).attr("name");
    $('#input').val(name);
    $('#board').submit();
  });

  $('td').on('click', function()
  {
    // Specify which cell to play next.
    let name = $(this).attr("name");
    $('#input').val(name);
    $('#board').submit();
  });
});
