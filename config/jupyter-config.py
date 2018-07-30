c.NotebookApp.password = u'sha1:e53fd6f0314f:5258851516a27b4a0a5dff6c53fe2f1156f39299'
c.NotebookApp.contents_manager_class = 'jgscm.GoogleStorageContentManager'
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.token = ''
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
c.NotebookApp.allow_root = True    # docker attach volume as root
c.GoogleStorageContentManager.default_path = '<enter your gcs path without leading /, eg bucket_name/folder_name>'
