# chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
#  if request.greeting is "walkthrough"
class Walkthrough
  @activate: () ->
    dialog = $("<div id='sigDialog'>").attr("title", "Welcome to Signifier!").appendTo(document.body)
    $("<p>").html(
      """
      To begin,
      <ol>
      <li>Highlight any text on this page.</li>
      <li>Click the sig button in the upper right hand corner of your browser.</li>
      <li>Click the make sign button</li>
      <li>Copy and paste your url into the dialog box.</li>
      </ol>
      """
    ).appendTo(dialog)
    dialog.dialog()
