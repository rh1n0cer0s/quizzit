module ApplicationHelper
  def back_url_hidden_field_tag
    back_url = params[:back_url] || request.env['HTTP_REFERER']
    back_url = CGI.unescape(back_url.to_s)
    hidden_field_tag('back_url', CGI.escape(back_url), :id => nil) unless back_url.blank?
  end

  def labelled_form_for(*args, &proc)
    args << {} unless args.last.is_a?(Hash)
    options = args.last
    if args.first.is_a?(Symbol)
      options.merge!(:as => args.shift)
    end
    html = {:class => "form-horizontal #{'wide' if options.delete(:wide)} #{options.delete(:class)}"}
    html[:data] ||= {}
    html[:data][:observe] = true if options.delete(:observe)
    options.merge!({:builder => Quizzit::Views::LabelledFormBuilder, :html => html})
    form_for(*args, &proc)
  end
end
