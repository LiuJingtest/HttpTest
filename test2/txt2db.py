#!/usr/bin/env python
#coding:utf-8

# import os
# import django
#
# os.environ.setdefault("DJANGO_SETTINGS_MODULE", "autotest_platform.settings")
#
# if django.VERSION >= (1, 7):#自动判断版本
#     django.setup()


# def main():
#     from blog.models import Blog
#     f = open('oldblog.txt')
#     for line in f:
#         title,content = line.split('****')
#         Blog.objects.get_or_create(title=title,content=content)
#     f.close()
# def main():
#     from blog.models import Blog
#     f = open('oldblog.txt')
#     BlogList = [Blog(title=line.split('****')[0], content=line.split('****')[1]) for line in f]
#
#     Blog.objects.bulk_create(BlogList)
#
# if __name__ == "__main__":
#     main()
#     print('Done!')