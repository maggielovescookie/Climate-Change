function(){
  tabPanel("About",
           HTML("
                <h3> Climate Change and Global Warming </h3> 
                <p> For centuries, the concentration of carbon dioxide had never been above 300 parts per million. However, now the level has across 400 parts per million. There is no question that increased levels of greenhouse gases must cause the Earth to warm in response. </p> 
                <p> Evidence is found in the data of Canadian temperature, it has risen about 1.07 degrees Celsius since the late 19th century, a change driven largely by increased carbon dioxide and other human-made emissions into the atmosphere. </p> 
                <p> Warm periods of spring-like weather during winter may more frequent melting of snow, as well as more frequent rainfall. This might not be obvious, but the snow cover in the Northern Hemisphere has decreased for past years.  </p>
                <p>Gloabl Warming is a real and climate change is a serious issue. </p>"
                ),
           HTML("<p> </p>
                <br/>
                <img src='pic.png'  alt='' style='height: 250px; width: 240px; '>
                <br/>
                <br/>
                <strong>Author</strong>
                <p>Qianhui (Maggie) Xu<br/>
                <a href='https://github.com/maggielovescookie' target='_blank'>Github</a> | 
                <a href='https://www.linkedin.com/in/qianhui-maggie-xu' target='_blank'>Linkedin</a> <br/>
                </p>
                <p> - A fourth-year data science major student. <br/>
                - Experience with C/C++, Python, Java, R, CSS, HTML<br/> 
                - Passionate about fine arts<br/>
                </p>
                <p><a href='https://sites.google.com/view/novus-cmpt276/' target='_blank'>YouFood</a> <br/> 
                - A mindful eating app based on the iOS platform, sharing recipes and calculating nutrition values</p>
                <div class='row'>
                <div class='col-sm-4'><strong>References</strong>
                <p></p><ul>
                <li><a href='http://shiny.rstudio.com/gallery/superzip-example.html' target='_blank'>SuperZIP</a></li>
                <li><a href='https://www.r-graph-gallery.com/299-circular-stacked-barplot/' target='_blank'> Circular Stacked Barplot</a></li>
                <li>Additional supporting R packages</li>
                <ul>
                <li><a href='http://rstudio.github.io/shinythemes/' target='_blank'>shinythemes</a></li>
                <li><a href='https://ggplot2.tidyverse.org/' target='_blank'>ggplot2</a></li>
                <li><a href='http://rstudio.github.io/leaflet/' target='_blank'>leaflet</a></li>
                </ul>
                
                </ul>"),#End of html part 2
           value="about"
           )
}