package org.akaza.openclinica.controller;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.akaza.openclinica.bean.core.Utils;
import org.akaza.openclinica.dao.hibernate.CrfDao;
import org.akaza.openclinica.dao.hibernate.EventCrfDao;
import org.akaza.openclinica.dao.hibernate.StudyDao;
import org.akaza.openclinica.domain.datamap.CrfBean;
import org.akaza.openclinica.domain.datamap.EventCrf;
import org.akaza.openclinica.domain.datamap.Study;
import org.apache.commons.lang.exception.ExceptionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(value = "/reporting")
public class MissingFormController {
    
    @Autowired
    StudyDao studyDao;
    
    @Autowired
    CrfDao crfDao;
    
    @Autowired
    EventCrfDao eventCrfDao;
    protected final Logger logger = LoggerFactory.getLogger(getClass().getName());

    @RequestMapping(value = "/study/{study}/missingForms", method = RequestMethod.GET)
    public void getMissingForms(@PathVariable("study") String studyOid, HttpServletResponse response) {
        
        try {
            Study study = studyDao.findByOcOID(studyOid);
            File report = createReport(study);
            
            response.setHeader("Content-Disposition", String.format("attachment; filename=" + report.getName()));
            response.setContentType("application/octet-stream");

            byte[] reportBytes = Files.readAllBytes(report.toPath());
            FileCopyUtils.copy(reportBytes, response.getOutputStream());
            
          } catch (IOException ex) {
            logger.error("Error writing report.");
            throw new RuntimeException("Error writing report.");
          }
    }

    private File createReport(Study study) throws IOException {
        File report = null;
        
        // Create the directory structure for saving the media
        String dir = Utils.getReportsRootPath();
        if (!new File(dir).exists()) {
            new File(dir).mkdirs();
            logger.debug("Made the directory " + dir);
        }

        //Create file object
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd-hh.mm.ss");
        String reportName = "formsPerMonth_" + formatter.format(new Date()) + ".csv";
        report = new File(dir + reportName);
        
        FileWriter writer = null;
        try {
            if (!report.exists()) report.createNewFile();
            writer = new FileWriter(report);
            writeReport(study, writer);
            writer.close();
        } catch (IOException ioe) {
            logger.error(ioe.getMessage());
            logger.error(ExceptionUtils.getStackTrace(ioe));
            throw ioe;
        } finally {
            writer.close();
        }
        return report;
    }

    private void writeReport(Study study, FileWriter writer) throws IOException {

        Calendar endCal = Calendar.getInstance();   // this takes current date
        Calendar startCal = Calendar.getInstance();
        startCal.setTime(endCal.getTime());
        startCal.set(Calendar.DAY_OF_MONTH, 1);
        startCal.set(Calendar.HOUR_OF_DAY, 0);
        startCal.set(Calendar.MINUTE, 0);
        startCal.set(Calendar.SECOND, 0);
        startCal.set(Calendar.MILLISECOND, 0);
        startCal.add(Calendar.MONTH, -3);

        Date endDate = endCal.getTime();
        Date startDate = startCal.getTime();
        SimpleDateFormat formatter = new SimpleDateFormat("MMM/dd/yyyy HH:mm:ss");
        System.out.println("StartDate: " + formatter.format(startDate) + ". EndDate:" + formatter.format(endDate));
        
        writer.write("Forms entered per month\n\n");
        writer.write("Today's Date:,");
        formatter.applyPattern("MMM dd yyyy");
        writer.write(formatter.format(endDate) + "\n\n");
        
        
        // Do header row:  CRF Name, curr month -3, curr month -2, curr month -1, curr month
        writer.write("CRF Name,");
        Calendar testCal = Calendar.getInstance();
        testCal.setTime(startCal.getTime());
        formatter.applyPattern("MMM");
        while (testCal.before(endCal)) {
            Date testDate = testCal.getTime();
            writer.write(formatter.format(testDate) + ",");
            testCal.add(Calendar.MONTH, 1);
        }
        writer.write("\n");
        
        
        
        List<CrfBean> crfs = crfDao.findAll();
        for (CrfBean crf:crfs) {
            writer.write(crf.getName() + ",");
           
            
            
            //TODO:  Will need to tweak this query to make a study level report include site entries
            List<EventCrf> eventCrfs = eventCrfDao.findByStudyCrfDateStarted(study.getStudyId(), crf.getCrfId(), startDate);
            System.out.println("For crf " + crf.getName() + ". Found " + eventCrfs.size() + " eventCrfs.");
            
            testCal.setTime(startCal.getTime());
            while (testCal.before(endCal)) {
                int testMonth = testCal.get(Calendar.MONTH);
                int testYear = testCal.get(Calendar.YEAR);
                int crfCount = 0;
                // 
                for (EventCrf eventCrf:eventCrfs) {
                    Calendar eventCal = Calendar.getInstance();
                    eventCal.setTime(eventCrf.getDateCreated());
                    int eventMonth = eventCal.get(Calendar.MONTH);
                    int eventYear = eventCal.get(Calendar.YEAR);
                    if (eventMonth == testMonth && eventYear == testYear) crfCount++;
                }
                writer.write(String.valueOf(crfCount) + ",");
                testCal.add(Calendar.MONTH, 1);
            }
            writer.write("\n");
        }
    }
}
