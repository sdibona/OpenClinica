package org.akaza.openclinica.control;

import org.akaza.openclinica.control.core.SecureController;
import org.akaza.openclinica.view.Page;
import org.akaza.openclinica.web.InsufficientPermissionException;

public class ReportManagerServlet extends SecureController{

    @Override
    protected void processRequest() throws Exception {
        forwardPage(Page.REPORT_MANAGER);
    }

    @Override
    protected void mayProceed() throws InsufficientPermissionException {
    }

}
