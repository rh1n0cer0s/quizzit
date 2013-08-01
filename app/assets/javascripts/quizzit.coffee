$.fn.handleAnswersForm = () ->
  form = $(this)
  table = form.find('.answers-table')
  add_answer = table.find('a.add-answer')
  delete_answer = table.find('a.delete-answer')
  template = table.find('tr.template')

  createAnswer = () ->
    tr = template.clone()
    tr.removeClass('template')
    tr.insertBefore(template)

  deleteAnswer = (elem) ->
    tr = elem.closest('tr')
    input = tr.find('input.input-destroy')
    console.log(input)
    input.val(true)
    if tr.hasClass('new-record')
      tr.remove()
    else
      tr.hide()
    false
  
  add_answer.click ->
    createAnswer()
    false

  form.on 'click', 'a.delete-answer', (event) =>
    deleteAnswer($(event.currentTarget))
    false

$.fn.handleQuizForm = () ->
  form = $(this)

  form.on "ajax:success", (event, xhr, status) ->
    if(xhr.result == false)
      form.after($('<p>').addClass('alert alert-error').html('Sorry, wrong answer.'))
    else
      form.after($('<p>').addClass('alert alert-success').html('Great, good answer!'))
     setTimeout(->
       window.location.reload()
     ,2000)


$ ->
	$('.answers-form').handleAnswersForm()
	$('.quiz-form').handleQuizForm()
