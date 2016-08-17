# from django.db import models
# from django.contrib import admin
#
# # Create your models here.
# class BlogsPost(models.Model):
#     title = models.CharField(max_length = 150)
#     body = models.TextField()
#     timestamp = models.DateTimeField()
#
# class BlogPostAdmin(admin.ModelAdmin):
#     list_display = ('title','timestamp')
#
# admin.site.register(BlogsPost,BlogPostAdmin)
#
# class InterfaceList(models.Model):
#     url = models.CharField(max_length=30)
#     method = models.CharField(max_length=7)
#     header = models.TextField()
#     request_body = models.TextField()
#     response_code = models.CharField(max_length=3)
#     response_body = models.TextField()
#
# class InterfaceListAdmin(admin.ModelAdmin):
#     list_display = ('url','method')
#
# admin.site.register(InterfaceList,InterfaceListAdmin)