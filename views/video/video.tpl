{{template "public/header.tpl" .}}
<style>
    .video-view { float: left; margin: 10px 10px 0 5px; width:240px;height:340px;text-align:center;z-index:1; position:relative;}
    .video-view:hover { background: #efefef;}
    .video-img {border: 1px solid #ddd;width:220px;height: 220px;}
    .video-img img { max-width:220px;height:220px}
    .video-info { width:220px;height:80px;margin-top: 30px;}
    .video-info p { line-height: 15px;text-align:left;word-wrap:break-word;word-break:break-all;}
    input.error, select.error {
        border: 1px solid #ff9999;
        background: #ffeeee;
    }
    label.error {
        font-size: .8em;color: #ff6666;display:inline;
    }
    .note {
        font-size: .8em;color: #a5a5a5;display:inline;float:left;
    }
    .operate span{
        margin-left:10px;
    }
    .operate span:hover{
        color: #ff7167;
    }
    .operate{
        float:right;margin-top: 4px;margin-right: 4px;
    }
</style>
<link rel="stylesheet" href="/static/css/jsgrid.min.css">
<link rel="stylesheet" href="/static/css/jsgrid-theme.min.css">
<link rel="stylesheet" href="/static/css/daterangepicker.css">
<link rel="stylesheet" href="/static/css/video-js.css">
<script src="/static/js/jsgrid.min.js"></script>
<script src="/static/js/jquery.validate.min.js"></script>
<script src="/static/js/jquery.form.min.js"></script>
<script src="/static/js/moment.min.js"></script>
<script src="/static/js/daterangepicker.js"></script>
<script src="/static/js/messager.js"></script>
<script src="/static/js/video.js"></script>
<script src="/static/admin/common.js"></script>
<script src="/static/admin/video.js"></script>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">
{{template "public/menu.tpl" .}}
    <script type="text/javascript">
        activeDiv=function () {
            $('#video-li').addClass("active");
        };
    </script>
    <div class="content-wrapper">
        <section class="content-header">
            <h1>视频信息</h1>
        </section>
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-body">
                            <div class="form-inline" style="height:35px">
                                <button id="addBtn" class="btn btn-primary">上传新视频</button>
                                <div style="float:right">
                                    <label>上传日期:</label>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <i class="fa fa-calendar"></i>
                                        </div>
                                        <input type="text" class="form-control pull-right" id="createTime">
                                        <input type="hidden" name="startDate">
                                        <input type="hidden" name="endDate">
                                    </div>
                                </div>
                            </div>
                            <div class="form-inline" style="margin:12px 0">
                                <select class="form-control input-sm" id="pageSize">
                                    <option selected="selected">10</option>
                                    <option>25</option>
                                    <option>50</option>
                                    <option>100</option>
                                </select>
                                <div style="float:right;display:inline">
                                    <input type="text" class="form-control input-sm" name="nameS" placeholder="名称">
                                    <button id="videoSearch" class="btn btn-primary btn-sm">搜索</button>
                                </div>
                            </div>
                            <div id="videoShow"></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
    <div id="videoModal" class="modal">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-body" style="text-align:center;height:520px;">
                    <video class="video-js" id="video" preload="auto" height="490px" controls data-setup='{}'>
                        <p class="vjs-no-js">
                            视频播放出错
                        </p>
                    </video>
                </div>
            </div>
        </div>
    </div>
    <div id="editModal" class="modal fade" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="box">
                    <div class="modal-header">
                        <button type="button" class="close closeBtn" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>
                        <h4 class="modal-title" id="modalLabel"></h4>
                    </div>
                    <form class="form-horizontal" id="videoForm">
                        <div class="modal-body" style="text-align:center;">
                            <input type="text" style="display:none;" name="id" id="id">
                            <div class="box-body">
                                <div class="form-group">
                                    <label for="name" class="col-sm-3 control-label">名称</label>
                                    <div class="col-sm-6">
                                        <input type="text" id="name" name="name" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="type" class="col-sm-3 control-label">类型</label>
                                    <div class="col-sm-6">
                                        <select id="type" name="type" class="form-control">
                                            <option value="">——请选择——</option>
                                            <option>巩固</option>
                                            <option>拓展</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="url" class="col-sm-3 control-label">视频</label>
                                    <div class="col-sm-6">
                                        <input type="file" id="url" name="url" class="form-control">
                                    </div>
                                    <label class="note">*无需修改时不用重新上传</label>
                                </div>
                                <div class="form-group">
                                    <label for="poster" class="col-sm-3 control-label">封面</label>
                                    <div class="col-sm-6">
                                        <input type="file" id="poster" name="poster" class="form-control">
                                    </div>
                                    <label class="note">*默认为视频第一帧，<br>可上传自定义封面</label>
                                </div>
                                <div class="form-group">
                                    <label for="brief" class="col-sm-3 control-label">描述</label>
                                    <div class="col-sm-6">
                                        <textarea id="brief" name="brief" class="form-control" rows="3"></textarea>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary" id="submitBtn">确定</button>
                            <button type="button" class="btn btn-default closeBtn">取消</button>
                        </div>
                    </form>
                    <div class="overlay" style="display: none;">
                        <i class="fa fa-refresh fa-spin"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
{{template "public/footer.tpl" .}}
