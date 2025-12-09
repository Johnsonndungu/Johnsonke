# frontend.jac

# Import the backend logic to enable access to 'fetch_and_predict_weather'
import:jac backend;

# The 'cl' block contains client-side Jac code (React components)
cl import from react {useState, useEffect}
cl {
    def WeatherDisplay() -> any {
        let [weatherData, setWeatherData] = useState(None);
        let [isLoading, setIsLoading] = useState(True);
        let location = "Garissa, Kenya";

        useEffect(lambda -> None {
            async def loadWeather() -> None {
                # **FRONTEND CALL USING spawn()**
                # Calls the walker defined in backend.jac
                result = root spawn fetch_and_predict_weather(location=location);
                
                if result.reports and len(result.reports[0]) > 0 {
                    setWeatherData(result.reports[0][0]);
                }
                setIsLoading(False);
            }
            loadWeather();
        }, []); 

        if isLoading {
            return <div style={{"padding": "20px", "textAlign": "center"}}>
                <h3>Fetching weather data for {location}...</h3>
            </div>;
        }

        if not weatherData {
            return <div style={{"padding": "20px", "color": "red", "textAlign": "center"}}>
                🚨 Error: Could not load weather data from the JAC backend.
            </div>;
        }
        
        # Displaying the fetched data using JSX
        return <div style={{
            "maxWidth": "600px",
            "margin": "50px auto",
            "padding": "30px",
            "border": "1px solid #ddd",
            "borderRadius": "10px",
            "boxShadow": "0 4px 8px rgba(0,0,0,0.1)",
            "fontFamily": "Arial, sans-serif"
        }}>
            <h1 style={{"textAlign": "center", "color": "#333"}}>Weather Report 🇰🇪</h1>
            <h2 style={{"textAlign": "center", "color": "#666"}}>{weatherData.location} Area</h2>
            <hr style={{"borderColor": "#eee", "marginBottom": "25px"}}/>
            
            {/* Current Weather Data */}
            <div style={{"marginBottom": "30px", "borderBottom": "1px dashed #eee", "paddingBottom": "20px"}}>
                <h3 style={{"color": "#FF9800"}}>🌤️ Current Conditions</h3>
                <p><strong>Temperature:</strong> <span style={{"fontSize": "1.2em", "fontWeight": "bold"}}>{weatherData.current_temp} °C</span></p>
                <p><strong>Condition:</strong> {weatherData.condition}</p>
            </div>

            {/* Weather Prediction Data */}
            <div style={{"padding": "15px", "borderLeft": "5px solid #4CAF50", "backgroundColor": "#E8F5E9", "borderRadius": "5px"}}>
                <h3 style={{"color": "#4CAF50"}}>🔮 Upcoming Weather Prediction</h3>
                <p><strong>Forecast:</strong> {weatherData.prediction}</p>
                <p><strong>Confidence:</strong> <span style={{"fontWeight": "bold"}}>{(weatherData.confidence * 100).toFixed(0)}%</span></p>
            </div>
        </div>;
    }

    # The required entry point for the entire JAC client application
    def app() -> any {
        return <WeatherDisplay />;
    }
}
