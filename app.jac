# frontend.jac - Garissa Kenya Weather Frontend (Client-side only)
# Pure React UI calling backend via spawn()

cl import from react {useState, useEffect}

cl {
    # Weather Card Component
    def WeatherCard(data: dict) -> any {
        return <div style={{
            "background": "#1E3A8A",
            "color": "white",
            "padding": "24px",
            "borderRadius": "16px",
            "margin": "12px 0",
            "boxShadow": "0 8px 32px rgba(0,0,0,0.1)"
        }}>
            <h3 style={{"margin": "0 0 16px 0", "fontSize": "24px"}}>
                {data.location}
            </h3>
            <div style={{"fontSize": "48px", "fontWeight": "bold", "marginBottom": "16px"}}>
                {data.current_temp}°C
            </div>
            <div style={{"fontSize": "20px", "opacity": 0.9, "marginBottom": "24px"}}>
                {data.current_condition}
            </div>
            <div style={{
                "display": "grid",
                "gridTemplateColumns": "repeat(auto-fit, minmax(120px, 1fr))",
                "gap": "12px",
                "fontSize": "14px"
            }}>
                <div>Humidity: {data.humidity}%</div>
                <div>Wind: {data.wind_speed} km/h</div>
                <div>Updated: {data.updated_at}</div>
            </div>
        </div>;
    }

    # Forecast Component
    def ForecastList(forecast: list) -> any {
        return <div style={{
            "background": "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
            "padding": "24px",
            "borderRadius": "16px",
            "marginTop": "24px"
        }}>
            <h3 style={{"color": "white", "margin": "0 0 20px 0", "textAlign": "center"}}>
                5-Day Weather Prediction
            </h3>
            <div style={{
                "display": "grid",
                "gridTemplateColumns": "repeat(auto-fit, minmax(140px, 1fr))",
                "gap": "16px"
            }}>
                {forecast.map(lambda day: any -> any {
                    return <div key={day.day} style={{
                        "background": "rgba(255,255,255,0.1)",
                        "padding": "20px 12px",
                        "borderRadius": "12px",
                        "textAlign": "center",
                        "backdropFilter": "blur(10px)"
                    }}>
                        <div style={{"fontSize": "18px", "fontWeight": "bold", "marginBottom": "8px"}}>
                            {day.day}
                        </div>
                        <div style={{"fontSize": "24px", "fontWeight": "600"}}>
                            {day.high}° / {day.low}°
                        </div>
                        <div style={{"fontSize": "14px", "opacity": 0.9, "marginTop": "4px"}}>
                            {day.condition}
                        </div>
                    </div>;
                })}
            </div>
        </div>;
    }

    # Main App - REQUIRED ENTRY POINT
    def app() -> any {
        let [weather, setWeather] = useState({});
        let [loading, setLoading] = useState(True);
        let [error, setError] = useState("");

        # Load weather on component mount
        useEffect(lambda -> None {
            async def loadWeather() -> None {
                try {
                    setLoading(True);
                    # SPAWN CALLS SEPARATE BACKEND WALKERS
                    result = root spawn get_weather();
                    weatherData = result.reports[0];
                    
                    formatted = {
                        "location": weatherData.location,
                        "current_temp": weatherData.current_temp,
                        "current_condition": weatherData.current_condition,
                        "humidity": weatherData.humidity,
                        "wind_speed": weatherData.wind_speed,
                        "forecast": weatherData.forecast,
                        "updated_at": weatherData.updated_at
                    };
                    
                    setWeather(formatted);
                } catch (e) {
                    setError("Failed to fetch weather data");
                } finally {
                    setLoading(False);
                }
            }
            loadWeather();
        }, []);

        # Loading state
        if loading {
            return <div style={{
                "display": "flex",
                "justifyContent": "center",
                "alignItems": "center",
                "height": "100vh",
                "fontSize": "24px",
                "color": "#64748B"
            }}>
                Loading Garissa weather...
            </div>;
        }

        # Error state
        if error {
            return <div style={{
                "display": "flex",
                "justifyContent": "center",
                "alignItems": "center",
                "height": "100vh",
                "color": "#EF4444",
                "fontSize": "20px"
            }}>
                {error}
            </div>;
        }

        return <div style={{
            "maxWidth": "1200px",
            "margin": "0 auto",
            "padding": "32px 20px",
            "fontFamily": "-apple-system, BlinkMacSystemFont, sans-serif"
        }}>
            <div style={{
                "textAlign": "center",
                "marginBottom": "40px"
            }}>
                <h1 style={{
                    "fontSize": "48px",
                    "background": "linear-gradient(135deg, #3B82F6, #1E40AF)",
                    "WebkitBackgroundClip": "text",
                    "WebkitTextFillColor": "transparent",
                    "margin": "0 0 12px 0"
                }}>
                    🌤️ Garissa, Kenya
                </h1>
                <p style={{"color": "#64748B", "fontSize": "18px"}}>
                    Real-time weather & 5-day forecast
                </p>
            </div>

            <WeatherCard data={weather} />
            <ForecastList forecast={weather.forecast} />

            # Refresh button - triggers backend spawn()
            <div style={{
                "textAlign": "center",
                "marginTop": "40px",
                "padding": "24px",
                "background": "#F8FAFC",
                "borderRadius": "12px"
            }}>
                <button 
                    onClick={lambda -> None {
                        setLoading(True);
                        async def refreshWeather() -> None {
                            try {
                                # SPAWN CALLS BACKEND WALKER
                                result = root spawn fetch_current_weather();
                                weatherData = result.reports[0];
                                formatted = {
                                    "location": weatherData.location,
                                    "current_temp": weatherData.current_temp,
                                    "current_condition": weatherData.current_condition,
                                    "humidity": weatherData.humidity,
                                    "wind_speed": weatherData.wind_speed,
                                    "forecast": weatherData.forecast,
                                    "updated_at": weatherData.updated_at
                                };
                                setWeather(formatted);
                            } catch (e) {
                                setError("Refresh failed");
                            } finally {
                                setLoading(False);
                            }
                        }
                        refreshWeather();
                    }}
                    style={{
                        "background": "#3B82F6",
                        "color": "white",
                        "border": "none",
                        "padding": "12px 32px",
                        "borderRadius": "12px",
                        "fontSize": "16px",
                        "fontWeight": "600",
                        "cursor": "pointer",
                        "boxShadow": "0 4px 12px rgba(59,130,246,0.3)"
                    }}
                >
                    🔄 Refresh Weather
                </button>
            </div>
        </div>;
    }
}
