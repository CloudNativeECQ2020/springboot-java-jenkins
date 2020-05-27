package hello;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.text.DateFormat;
import java.net.InetAddress;
import java.net.UnknownHostException;
 
@SpringBootApplication
@RestController
public class Application {

  @RequestMapping("/")
  public String home() {
	DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	Date date = new Date();
	String display_date = "System date: " + dateFormat.format(date);


    return "<h1>Hello Docker World coming to you from Spring Boot+java, in a container!</h1>"
		+display_date 
		+ "<h3>" + getIPHost() + "</h3>" 
		+ "<br><h2> AWS deploy success </h2>"
		+ "<br><h2> AWS ECR (load image after update) succsess </h2>";

  }
  public static void main(String[] args) {
    SpringApplication.run(Application.class, args);
  }

  public String  getIPHost() {
 
      InetAddress ip;
      String ipandname = "Error occured";
      try {
        ip = InetAddress.getLocalHost();
        ipandname = "IP Address: "+ InetAddress.getLocalHost();
//	ipandname = ipandname.split("\\\\")[1];
        ipandname += "<br>Hostname: " + ip.getHostName();
       } catch (UnknownHostException e) { 
            e.printStackTrace();
       }
       return ipandname;
    }

}
