//
//  WSLinePlotFactory.h
//  PowerPlot
//
//  Created by Wolfram Schroers on 15.10.10.
//  Copyright 2010-2013 Numerik & Analyse Schroers. All rights reserved.
//

#import "WSChart.h"
#import "WSPlotFactoryDefaults.h"

@class WSColorScheme;

/** Styles a line chart can be generated by this category. */
typedef NS_ENUM(NSInteger, LPStyle) {
    kChartLineEmpty = -1, ///< Do not draw anything.
    kChartLinePlain,      ///< Chart with a single line.
    kChartLineFilled,     ///< Chart with a line and solid fill it up/down to the abscissa.
    kChartLineGradient,   ///< Chart with a line and gradient fill it up/down to the abscissa.
    kChartLineScientific  ///< Chart with a single line, error bars and symbols.
};

/**  @brief This category defines factory methods for line plots.
 
     This category defines a series of factory methods providing
     charts with line plots based on commonly used designs. The user
     can choose several default styles and methods to display the
     data. Note that it is still possible to configure all properties
     of charts generated this way and that it is similarly possible to
     add custom plots, too. An important point to be aware of is that
     an autogenerated chart usually employs the design pattern that
     each plot in the chart has a single data set and coordinate
     system only!  When adding custom plots the user may or may not
     follow this behavior.
 */
@interface WSChart (WSLinePlotFactory)

/** Create a chart with coordinate axis and a line plot.

    @return A new @p WSChart with a coordinate axis and a line plot.
 */
+ (instancetype)linePlotWithFrame:(CGRect)frame
                             data:(WSData *)data
                            style:(LPStyle)style
                        axisStyle:(CSStyle)axis
                      colorScheme:(WSColorScheme *)colorScheme
                           labelX:(NSString *)labelX
                           labelY:(NSString *)labelY;

/** Create a chart with coordinate axis and a line plot.
 
    @return A new @p WSChart with a coordinate axis and a line plot.
 */
+ (instancetype)linePlotWithFrame:(CGRect)frame
                             data:(WSData *)data
                            style:(LPStyle)style
                        axisStyle:(CSStyle)axis
                           colors:(LPColorScheme)colors
                           labelX:(NSString *)labelX
                           labelY:(NSString *)labelY;

/** @brief Configure the current chart instance.
 
    The instance will have all previous data removed and contain a
    line plot and an axis plot with appropriate configuration.

    @param data Input data set.
    @param style Style of the resulting chart.
    @param axis Style of the coordinate axis in the result chart.
    @param colors Resulting color scheme.
    @param labelX X-axis label.
    @param labelY Y-axis label.
 */
- (void)configureWithData:(WSData *)data
                    style:(LPStyle)style
                axisStyle:(CSStyle)axis
              colorScheme:(WSColorScheme *)colors
                   labelX:(NSString *)labelX
                   labelY:(NSString *)labelY;

@end