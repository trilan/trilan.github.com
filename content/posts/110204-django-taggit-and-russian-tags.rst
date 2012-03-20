django-taggit и русские теги
============================

:date: 2011-02-04
:slug: django-taggit-and-russian-tags
:tags: django, django-taggit
:author: Mike Yumatov

Существует замечательное приложение django-taggit_, позволяющее быстро и просто
добавить теги к объектам на сайте. Использовать его легче некуда::

    from django.db import models
    from taggit.managers import TaggableManager

    class Article(models.Model):
        # ...
        tags = TaggableManager()

.. _django-taggit: https://github.com/alex/django-taggit

Но существует небольшая проблема. При сохранении тега приложение генерирует на
основе его имени уникальный код, который удобно использовать в URL.
К сожалению, по-умолчанию из этого кода удаляются все не-ASCII символы, в том
числе и русские. В итоге вместо «мир», «труд», «май» получаем «» (пустая
строка), «_1» и «_2», что не очень хорошо.

Первая мысль — надо форкнуть и пропатчить проект. Но после ознакомления с
`его документацией`_ и `кодом`_ оказывается, что все гораздо проще. В Django,
начиная с версии 1.1, можно создавать так называемые прокси-модели.
Прокси-модель — это дочерний от обычной модели класс, в котором  можно изменить
ее поведение, используя при этом ту же самую таблицу базы данных, а значит, те
же самые данные. `Подробнее о прокси-моделях`_

.. _его документацией: http://django-taggit.readthedocs.org/en/latest/index.html
.. _кодом: https://github.com/alex/django-taggit/blob/master/taggit/models.py
.. _Подробнее о прокси-моделях: http://docs.djangoproject.com/en/1.2/topics/db/models/#proxy-models

В документации к django-taggit описывается возможность указать с помощью
атрибута ``through`` у ``TaggableManager`` модель, связывающую объекты с
тегами. В качестве такой модели можно «подсунуть» прокси-модель,
переопределяющую метод класса ``tag_model``, который, в свою очередь возвращает
другую прокси-модель, меняющую способ создания уникального кода тега.

Вот что получилось в итоге::

    from django.db import models

    from taggit.managers import TaggableManager
    from taggit.models import Tag, TaggedItem

    class ArticleTag(Tag):
        class Meta:
            proxy = True

        def slugify(self, tag, i=None):
            slug = tag.lower().replace(' ', '-')
            if i is not None:
                slug += '-%d' % i
            return slug

    class ArticleTaggedItem(TaggedItem):
        class Meta:
            proxy = True

        @classmethod
        def tag_model(cls):
            return ArticleTag

    class Article(models.Model):
        # other fields
        tags = TaggableManager(through=ArticleTaggedItem)

Этот прием был найден в тестах к приложению, но почему-то не документирован.
