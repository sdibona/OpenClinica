package org.akaza.openclinica.service.pform;

import java.util.Collections;
import java.util.List;

import javax.annotation.PostConstruct;

import org.akaza.openclinica.service.pform.processor.Processor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.AnnotationAwareOrderComparator;
import org.springframework.stereotype.Component;

@Component
public class SubmissionProcessorChain {
    
    @Autowired
    List<Processor> processors;
    
    @PostConstruct
    public void init() {
        Collections.sort(processors, AnnotationAwareOrderComparator.INSTANCE);
    }

    //@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
    public void processSubmission(SubmissionContainer container) throws Exception {
        for (Processor processor:processors) {
            processor.process(container);
        }
    }
}
