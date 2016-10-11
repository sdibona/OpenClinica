<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<fmt:setBundle basename="org.akaza.openclinica.i18n.notes" var="restext"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.workflow" var="resworkflow"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.words" var="resword"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.format" var="resformat"/>
<c:set var="dteFormat"><fmt:message key="date_format_string" bundle="${resformat}"/></c:set>
<c:choose>
    <c:when test="${isAdminServlet == 'admin' && userBean.sysAdmin && module=='admin'}">
        <c:import url="include/admin-header.jsp"/>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${userRole.manageStudy && module=='manage'}">
                <c:import url="include/managestudy-header.jsp"/>
            </c:when>
            <c:otherwise>
                <c:import url="include/submit-header.jsp"/>
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>

<script type="text/JavaScript" language="JavaScript" src="includes/jmesa/jquery.min.js"></script>
<script type="text/javascript" language="JavaScript" src="includes/jmesa/jquery-migrate-1.1.1.js"></script>
<script type="text/javascript" language="javascript">

    function studySubjectResource()  { return "${study.oid}/${studySub.oid}"; }

    function checkCRFLocked(ecId, url){
        jQuery.post("CheckCRFLocked?ecId="+ ecId + "&ran="+Math.random(), function(data){
            if(data == 'true'){
                window.location = url;
            }else{
                alert(data);return false;
            }
        });
    }
    function checkCRFLockedInitial(ecId, formName){
        if(ecId==0) {formName.submit(); return;}
        jQuery.post("CheckCRFLocked?ecId="+ ecId + "&ran="+Math.random(), function(data){
            if(data == 'true'){
                formName.submit();
            }else{
                alert(data);
            }
        });
    }
</script>

<!-- move the alert message to the sidebar-->
<jsp:include page="include/sideAlert.jsp"/>
<!-- then instructions-->
<tr id="sidebar_Instructions_open" style="display: none">
    <td class="sidebar_tab">

        <a href="javascript:leftnavExpand('sidebar_Instructions_open'); leftnavExpand('sidebar_Instructions_closed');"><img src="images/sidebar_collapse.gif" border="0" align="right" hspace="10"></a>

        <b><fmt:message key="instructions" bundle="${restext}"/></b>

        <div class="sidebar_tab_content">
        </div>

    </td>

</tr>
<tr id="sidebar_Instructions_closed" style="display: all">
    <td class="sidebar_tab">

        <a href="javascript:leftnavExpand('sidebar_Instructions_open'); leftnavExpand('sidebar_Instructions_closed');"><img src="images/sidebar_expand.gif" border="0" align="right" hspace="10"></a>

        <b><fmt:message key="instructions" bundle="${restext}"/></b>

    </td>
</tr>
<jsp:include page="include/sideInfo.jsp"/>


<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr><td>
        <h1>
            <div class="title_manage">
                <c:out value="${study.name}"/>: View Reports
           </div>
        </h1>
        </td>
    </tr>
</table>


<c:choose>
    <c:when test="${isAdminServlet == 'admin' && userBean.sysAdmin && module=='admin'}">
        <div class="table_title_Admin">
    </c:when>
    <c:otherwise>

        <c:choose>
            <c:when test="${userRole.manageStudy}">
                <div class="table_titla_manage">
            </c:when>
            <c:otherwise>
                <div class="table_title_submit">
            </c:otherwise>
        </c:choose>

    </c:otherwise>
</c:choose>

<div id="studySubjectRecord">

<table border="0" cellpadding="0" cellspacing="0">
        <tbody><tr>

            <td style="padding-right: 20px;" valign="top" width="800">



    <!-- These DIVs define shaded box borders -->

        <div class="box_T"><div class="box_L"><div class="box_R"><div class="box_B"><div class="box_TL"><div class="box_TR"><div class="box_BL"><div class="box_BR">

            <div class="tablebox_center">

            <table width="800" border="0" cellpadding="0" cellspacing="0">

        <!-- Table Actions row (pagination, search, tools) -->

                <tbody>
        <!-- end Table Actions row (pagination, search, tools) -->

                <tr>
                    <td valign="top">

            <!-- Table Contents -->

                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tbody>
                        <tr>
                            <td class="table_header_row_left">Dataset Name</td>
                            <td class="table_header_row">Description</td>
                            <td class="table_header_row">Actions</td>
                        </tr>
                        
                        <tr>
                            <td class="table_cell">Missing Forms</td>
                            <td class="table_cell">Expected vs missing forms for last 3 months</td>
                            <td class="table_cell">
                                <a href="pages/reporting/study/<c:out value="${study.oid}"/>/missingForms"
                                    onMouseDown="javascript:setImage('bt_View1','images/bt_View_d.gif');"
                                    onMouseUp="javascript:setImage('bt_View1','images/bt_View.gif');">
                                    <img name="bt_View1" src="images/bt_View.gif" border="0" alt="<fmt:message key="view_default" bundle="${resword}"/>" title="<fmt:message key="view_default" bundle="${resword}"/>" align="left" hspace="6">
                                </a>
                                <a href="pages/reporting/study/<c:out value="${study.oid}"/>/missingForms"
                                    onMouseDown="javascript:setImage('bt_Export1','images/bt_Export_d.gif');"
                                    onMouseUp="javascript:setImage('bt_Export1','images/bt_Export.gif');">
                                    <img name="bt_View1" src="images/bt_Export.gif" border="0" alt="<fmt:message key="export_dataset" bundle="${resword}"/>" title="<fmt:message key="export_dataset" bundle="${resword}"/>" align="left" hspace="6">
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td class="table_cell">SDV completion tracking</td>
                            <td class="table_cell">% complete of all forms requiring SDV</td>
                            <td class="table_cell">
                                <a href="pages/reporting/study/<c:out value="${study.oid}"/>/missingForms"
                                    onMouseDown="javascript:setImage('bt_View1','images/bt_View_d.gif');"
                                    onMouseUp="javascript:setImage('bt_View1','images/bt_View.gif');">
                                    <img name="bt_View1" src="images/bt_View.gif" border="0" alt="<fmt:message key="view_default" bundle="${resword}"/>" title="<fmt:message key="view_default" bundle="${resword}"/>" align="left" hspace="6">
                                </a>
                                <a href="pages/reporting/study/<c:out value="${study.oid}"/>/missingForms"
                                    onMouseDown="javascript:setImage('bt_Export1','images/bt_Export_d.gif');"
                                    onMouseUp="javascript:setImage('bt_Export1','images/bt_Export.gif');">
                                    <img name="bt_View1" src="images/bt_Export.gif" border="0" alt="<fmt:message key="export_dataset" bundle="${resword}"/>" title="<fmt:message key="export_dataset" bundle="${resword}"/>" align="left" hspace="6">
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td class="table_cell">Forms entered per month</td>
                            <td class="table_cell">Number of event CRFs entered for last 3 months</td>
                            <td class="table_cell">
                                <a href="pages/reporting/study/<c:out value="${study.oid}"/>/missingForms"
                                    onMouseDown="javascript:setImage('bt_View1','images/bt_View_d.gif');"
                                    onMouseUp="javascript:setImage('bt_View1','images/bt_View.gif');">
                                    <img name="bt_View1" src="images/bt_View.gif" border="0" alt="<fmt:message key="view_default" bundle="${resword}"/>" title="<fmt:message key="view_default" bundle="${resword}"/>" align="left" hspace="6">
                                </a>
                                <a href="pages/reporting/study/<c:out value="${study.oid}"/>/missingForms"
                                    onMouseDown="javascript:setImage('bt_Export1','images/bt_Export_d.gif');"
                                    onMouseUp="javascript:setImage('bt_Export1','images/bt_Export.gif');">
                                    <img name="bt_View1" src="images/bt_Export.gif" border="0" alt="<fmt:message key="export_dataset" bundle="${resword}"/>" title="<fmt:message key="export_dataset" bundle="${resword}"/>" align="left" hspace="6">
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td class="table_cell">Double data entry reconciliation</td>
                            <td class="table_cell">Comparison of first and second pass data entry</td>
                            <td class="table_cell">
                                <a href="pages/reporting/study/<c:out value="${study.oid}"/>/missingForms"
                                    onMouseDown="javascript:setImage('bt_View1','images/bt_View_d.gif');"
                                    onMouseUp="javascript:setImage('bt_View1','images/bt_View.gif');">
                                    <img name="bt_View1" src="images/bt_View.gif" border="0" alt="<fmt:message key="view_default" bundle="${resword}"/>" title="<fmt:message key="view_default" bundle="${resword}"/>" align="left" hspace="6">
                                </a>
                                <a href="pages/reporting/study/<c:out value="${study.oid}"/>/missingForms"
                                    onMouseDown="javascript:setImage('bt_Export1','images/bt_Export_d.gif');"
                                    onMouseUp="javascript:setImage('bt_Export1','images/bt_Export.gif');">
                                    <img name="bt_View1" src="images/bt_Export.gif" border="0" alt="<fmt:message key="export_dataset" bundle="${resword}"/>" title="<fmt:message key="export_dataset" bundle="${resword}"/>" align="left" hspace="6">
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td class="table_cell">Custom report 1: Patient count having HIV and hepatitis C</td>
                            <td class="table_cell">Custom report for HIV study</td>
                            <td class="table_cell">
                                <a href="pages/reporting/study/<c:out value="${study.oid}"/>/missingForms"
                                    onMouseDown="javascript:setImage('bt_View1','images/bt_View_d.gif');"
                                    onMouseUp="javascript:setImage('bt_View1','images/bt_View.gif');">
                                    <img name="bt_View1" src="images/bt_View.gif" border="0" alt="<fmt:message key="view_default" bundle="${resword}"/>" title="<fmt:message key="view_default" bundle="${resword}"/>" align="left" hspace="6">
                                </a>
                                <a href="pages/reporting/study/<c:out value="${study.oid}"/>/missingForms"
                                    onMouseDown="javascript:setImage('bt_Export1','images/bt_Export_d.gif');"
                                    onMouseUp="javascript:setImage('bt_Export1','images/bt_Export.gif');">
                                    <img name="bt_View1" src="images/bt_Export.gif" border="0" alt="<fmt:message key="export_dataset" bundle="${resword}"/>" title="<fmt:message key="export_dataset" bundle="${resword}"/>" align="left" hspace="6">
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td class="table_cell">Custom report 2: Patient count having hypertension and taking medication Accupril</td>
                            <td class="table_cell">Custom report for HIV study</td>
                            <td class="table_cell">
                                <a href="pages/reporting/study/<c:out value="${study.oid}"/>/missingForms"
                                    onMouseDown="javascript:setImage('bt_View1','images/bt_View_d.gif');"
                                    onMouseUp="javascript:setImage('bt_View1','images/bt_View.gif');">
                                    <img name="bt_View1" src="images/bt_View.gif" border="0" alt="<fmt:message key="view_default" bundle="${resword}"/>" title="<fmt:message key="view_default" bundle="${resword}"/>" align="left" hspace="6">
                                </a>
                                <a href="pages/reporting/study/<c:out value="${study.oid}"/>/missingForms"
                                    onMouseDown="javascript:setImage('bt_Export1','images/bt_Export_d.gif');"
                                    onMouseUp="javascript:setImage('bt_Export1','images/bt_Export.gif');">
                                    <img name="bt_View1" src="images/bt_Export.gif" border="0" alt="<fmt:message key="export_dataset" bundle="${resword}"/>" title="<fmt:message key="export_dataset" bundle="${resword}"/>" align="left" hspace="6">
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td class="table_cell">Custom report 3: CD4 counts over time</td>
                            <td class="table_cell">Custom report for HIV study</td>
                            <td class="table_cell">
                                <a href="pages/reporting/study/<c:out value="${study.oid}"/>/missingForms"
                                    onMouseDown="javascript:setImage('bt_View1','images/bt_View_d.gif');"
                                    onMouseUp="javascript:setImage('bt_View1','images/bt_View.gif');">
                                    <img name="bt_View1" src="images/bt_View.gif" border="0" alt="<fmt:message key="view_default" bundle="${resword}"/>" title="<fmt:message key="view_default" bundle="${resword}"/>" align="left" hspace="6">
                                </a>
                                <a href="pages/reporting/study/<c:out value="${study.oid}"/>/missingForms"
                                    onMouseDown="javascript:setImage('bt_Export1','images/bt_Export_d.gif');"
                                    onMouseUp="javascript:setImage('bt_Export1','images/bt_Export.gif');">
                                    <img name="bt_View1" src="images/bt_Export.gif" border="0" alt="<fmt:message key="export_dataset" bundle="${resword}"/>" title="<fmt:message key="export_dataset" bundle="${resword}"/>" align="left" hspace="6">
                                </a>
                            </td>
                        </tr>
                    </tbody></table>

            <!-- End Table Contents -->

                    </td>
                </tr>
            </tbody></table>


            </div>

        </div></div></div></div></div></div></div></div>

            </td>
        </tr>
    </tbody></table>
    <br>


</div>

<!-- End Main Content Area -->



<jsp:include page="include/footer.jsp"/>
