HTMLWidgets.widget({

  name: 'd3vt',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {
        if(x.options.seed!=null){
          Math.seedrandom(x.options.seed);
        }
        
        var _2PI = 2*Math.PI;
      //end: constants
      //begin: layout conf.
      if(width==null){
        var svgWidth = 960;
      }else{
        svgWidth = width;
      }
      if(height==null){
        svgHeight = 500;
      }else{
        svgHeight = height;
      }
      var    margin = {top: height*10/500, right: width*10/960, bottom: height*10/500, left: width*10/960},
          heightT = svgHeight - margin.top - margin.bottom,
          widthT = svgWidth - margin.left - margin.right,
          halfWidth = widthT/2,
          halfHeight = heightT/2,
          quarterWidth = widthT/4,
          quarterHeight = heightT/4,
          titleY = height*20/500,
          legendsMinY = heightT - height*20/500,
          treemapCenter = [halfWidth, halfHeight+height*5/500];
          var treemapRadius = Math.min(width*205/960, halfHeight-height*10/500, halfWidth-width*10/960);
          if(!x.options.legend){
            var treemapRadius = Math.min(width*340/960, halfHeight-height*10/500,halfWidth-width*10/960);
          }
          
      //end: layout conf.
      var svg = d3.select(el)
                    .append("svg")
                    .style("width", "100%")
                    .style("height", "100%");
                    //.style("background-color","rgb(250,250,250)");
      //begin: treemap conf.
      var _voronoiTreemap = d3.voronoiTreemap();
      var hierarchy, circlingPolygon;
      //end: treemap conf.
      
      //begin: drawing conf.
      var fontScale = d3.scaleLinear();
      //end: drawing conf.
      
      //begin: reusable d3Selection
      
      var drawingArea, treemapContainer;
      //end: reusable d3Selection
      
      function initData(rootData) {
        circlingPolygon = computeCirclingPolygon(treemapRadius);
        fontScale.domain([3, 20]).range([8, 20]).clamp(true);
      }
      
      function computeCirclingPolygon(radius) {
        var points = 60,
            increment = _2PI/points,
            circlingPolygon = [];
        
        for (var a=0, i=0; i<points; i++, a+=increment) {
          circlingPolygon.push(
            [radius + radius*Math.cos(a), radius + radius*Math.sin(a)]
          )
        }
        
      	return circlingPolygon;
      };
      
      function initLayout(rootData) {
        drawingArea = svg.append("g")
        	.classed("drawingArea", true)
        	.attr("transform", "translate("+[margin.left,margin.top]+")");
        
        treemapContainer = drawingArea.append("g")
        	.classed("treemap-container", true)
        	.attr("transform", "translate("+treemapCenter+")");
        
        treemapContainer.append("path")
        	.classed("world", true)
        	.attr("transform", "translate("+[-treemapRadius,-treemapRadius]+")")
        	.attr("d", "M"+circlingPolygon.join(",")+"Z")
        	.style("stroke",x.colors.circle).style("stroke-width",x.size.circle)
        	;
        if(x.options.title!=null){
          drawTitle();
        }
        if(x.options.footer!=null){
          drawFooter();  
        }
        if(x.options.legend){
          drawLegends(rootData);  
        }
      }
      
      function drawTitle() {
        drawingArea.append("text")
        	.attr("id", "title")
        	.attr("transform", "translate("+[halfWidth, titleY]+")")
        	.attr("text-anchor", "middle")
          .text(x.options.title);
      }
      
      function drawFooter() {
        drawingArea.append("text")
        	.classed("tiny light", true)
        	.attr("transform", "translate("+[0, heightT]+")")
        	.attr("text-anchor", "start")
        	.text(x.options.footer)
      }
      
      function drawLegends(rootData) {
        var legendHeight = height*13/500,
            interLegend = height*4/500,
            colorWidth = legendHeight*6,
            continents = rootData.children.reverse();
        var legendContainer = drawingArea.append("g")
        	.classed("legend", true)
        	.attr("transform", "translate("+[0, legendsMinY]+")");
        
        var legends = legendContainer.selectAll(".legend")
        	.data(continents)
        	.enter();
        
        var legend = legends.append("g")
        	.classed("legend", true)
        	.attr("transform", function(d,i){
            return "translate("+[0, -i*(legendHeight+interLegend)]+")";
          })
        	
        legend.append("rect")
        	.classed("legend-color", true)
        	.attr("y", -legendHeight)
        	.attr("width", colorWidth)
        	.attr("height", legendHeight)
        	.style("fill", function(d){ return d.color; });
        legend.append("text")
        	.classed("tiny", true)
        	.attr("transform", "translate("+[colorWidth+5, -2]+")")
        	.text(function(d){ return d.name; });
        if(x.options.legend_title!=null){
          legendContainer.append("text")
        	  .attr("transform", "translate("+[0, -continents.length*(legendHeight+interLegend)-5]+")").text(x.options.legend_title);
          
        }
      }
      
      function drawTreemap(hierarchy) {
        var leaves=hierarchy.leaves();
        
        var cells = treemapContainer.append("g")
        	.classed('cells', true)
        	.attr("transform", "translate("+[-treemapRadius,-treemapRadius]+")")
	        .selectAll(".cell")
        	.data(leaves)
        	.enter()
        		.append("path")
        			.classed("cell", true)
        			.attr("d", function(d){ return "M"+d.polygon.join(",")+"z"; })
        			.style("fill", function(d){
        			  //return d.parent.data.color;
        			  //use an individual color to make it more flexibel (parent would be the color of the continent)
                return d.data.color;
          		}).style("stroke",x.colors.border).style("stroke-width",x.size.border)
          		;
        if(x.options.label){
        var labels = treemapContainer.append("g")
        	.classed('labels', true)
        	.attr("transform", "translate("+[-treemapRadius,-treemapRadius]+")")
	        .selectAll(".label")
        	.data(leaves)
        	.enter()
        		.append("g")
        			.classed("label", true)
        			.attr("transform", function(d){
          			return "translate("+[d.polygon.site.x, d.polygon.site.y]+")";
              })
        			.style("font-size", function(d){ return fontScale(d.data.weight); });
        labels.append("text")
        	.classed("name", true)
        	.html(function(d){
        	  return(d.data.code)
          	//return (d.data.weight<1)? d.data.code : d.data.name;
        	});
        }
//        labels.append("text")
//        	.classed("value", true)
//        	.text(function(d){ return d.data.weight+"%"; });
        var hoverers = treemapContainer.append("g")
        	.classed('hoverers', true)
        	.attr("transform", "translate("+[-treemapRadius,-treemapRadius]+")")
	        .selectAll(".hoverer")
        	.data(leaves)
        	.enter()
        		.append("path")
        			.classed("hoverer", true)
        			.attr("d", function(d){ return "M"+d.polygon.join(",")+"z"; })
        			.style("fill","transparent")
        			.style("stroke",x.colors.border);//.style("stroke-width","0px");
// inject a css style for hover             
//TODO: make more than the stroke width changeable
        var css = '.hoverer:hover{ stroke-width:';
        css=css.concat(x.size.border_hover);
        css=css.concat('}');
       var style = document.createElement('style');
      if (style.styleSheet) {
        style.styleSheet.cssText = css;
      } else {
        style.appendChild(document.createTextNode(css));
      }
      document.getElementsByTagName('head')[0].appendChild(style);
// end inject a css style for hover      
        hoverers.append("title")
          .text(function(d) { return d.data.name + "\n" + d.value+"%"; });
      };
 // Code Run     
        var rootData = JSON.parse(x.data);
//        window.testvar=rootData;
        initData();
        initLayout(rootData);
        
        hierarchy = d3.hierarchy(rootData).sum(function(d){ return d.weight; });
        _voronoiTreemap
          .clip(circlingPolygon)
        	(hierarchy);
        
        drawTreemap(hierarchy);
      
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});