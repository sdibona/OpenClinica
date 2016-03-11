package org.akaza.openclinica.service.pform.processor;

import org.akaza.openclinica.service.pform.SubmissionContainer;

public interface Processor {

    public void process(SubmissionContainer container) throws Exception;

}
