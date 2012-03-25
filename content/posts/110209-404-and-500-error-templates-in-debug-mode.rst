Шаблоны для 404 и 500 ошибок в режиме отладки
=============================================

:date: 2011-02-09
:slug: 405-and-500-error-templates-in-debug-mode
:tags: django
:author: Mike Yumatov
:summary:
    Как известно, в режиме отладки Django по случаю 404 и 500 ошибок отдает нам
    собственные страницы с полезной информацией. Но иногда очень хочется
    протестировать шаблоны ``404.html`` и ``500.html``. Самый простой способ это
    сделать — добавить в самый низ URLConf проекта следующие строки.

Как известно, в режиме отладки Django по случаю 404 и 500 ошибок отдает нам
собственные страницы с полезной информацией. Но иногда очень хочется
протестировать шаблоны ``404.html`` и ``500.html``. Самый простой способ это
сделать — добавить в самый низ URLConf проекта следующие строки.

Для Django 1.2.* и ниже::

    if settings.DEBUG:
        urlpatterns += patterns('django.views.generic.simple',
            url(r'^404$', 'direct_to_template', {'template': '404.html'}),
            url(r'^500$', 'direct_to_template', {'template': '500.html'}),
        )

Для Django 1.3 и выше::

    if settings.DEBUG:
        urlpatterns += patterns('',
            url(r'^404$', TemplateView.as_view(template_name='404.html')),
            url(r'^500$', TemplateView.as_view(template_name='500.html')),
        )

Теперь по адресам ``http://example.com/404`` и ``http://example.com/500`` можно
смотреть, как выглядят страницы ошибок на вашем сайте :)
