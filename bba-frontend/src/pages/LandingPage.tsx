import { useState } from "react";
import Logo from "../components/Logo";
import PlayerList from "../components/PlayerList";
import Standing from "../components/Standing";
import Schedule from "../components/Schedule";

interface Player {
    name: string;
    avatar_path: string | null,
    age: number,
    position: string;
    number: number;
    height: number;
    weight: number;
    ppg?: number;
    rpg?: number;
    apg?: number;
    spg?: number;
    bpg?: number;
    mpg?: number;
    fg_pct?: number;
    three_pct?: number;
    ft_pct?: number;
    ts_pct?: number;
}

function LandingPage() {
    const [selectedPlayer, setSelectedPlayer] = useState<Player | null>(null);
    const [viewMode, setViewMode] = useState<"schedule" | "player">("schedule");

    return (
        <div className="h-screen w-screen bg-primary flex flex-col items-center p-6 text-black">
            <div className="w-full max-w-7xl flex gap-6 mb-6">
                <div className="w-56 bg-white shadow-md p-4 rounded-lg flex items-center justify-center">
                    <Logo />
                </div>

                <div className="flex-1 bg-white shadow-md p-4 rounded-lg flex items-center justify-center">
                    <PlayerList
                        onSelect={(player) => {
                            setSelectedPlayer(player);
                            setViewMode("player");
                        }}
                    />
                </div>
            </div>

            <div className="w-full max-w-7xl flex gap-6">
                <div className="bg-white shadow-md p-4 rounded-lg">
                    <Standing />
                </div>

                <div className="flex-1 bg-white shadow-md p-4 rounded-lg">
                    {viewMode === "schedule" ? (
                        <Schedule />
                    ) : (
                        <div className="text-center">
                            <div className="w-full bg-primary text-white shadow-md p-4 rounded-lg flex items-center">
                                {selectedPlayer?.avatar_path ? (
                                    <img src={selectedPlayer?.avatar_path} alt={selectedPlayer?.name} className="w-30 h-28 rounded-full object-cover" />
                                ) : (
                                    <img src={'/null.jpg'} alt={selectedPlayer?.name} className="w-30 h-28 rounded-full object-cover" />
                                )}

                                <div className="flex-1 flex flex-col items-center text-center">
                                    <h1 className="text-2xl font-bold">{selectedPlayer?.name}</h1>
                                    <p>Position: {selectedPlayer?.position}</p>
                                    <p>Number: #{selectedPlayer?.number}</p>
                                    <p>Height: {selectedPlayer?.height} m</p>
                                    <p>Weight: {selectedPlayer?.weight} kg</p>
                                </div>
                            </div>
                            <br />
                            <div className="w-full bg-white text-black shadow-md p-4 rounded-lg items-center gap-12">
                                <div className="grid grid-cols-3 gap-4 text-lg">
                                    <p><strong>PPG:</strong> {selectedPlayer?.ppg ?? "N/A"}</p>
                                    <p><strong>RPG:</strong> {selectedPlayer?.rpg ?? "N/A"}</p>
                                    <p><strong>APG:</strong> {selectedPlayer?.apg ?? "N/A"}</p>
                                    <p><strong>SPG:</strong> {selectedPlayer?.spg ?? "N/A"}</p>
                                    <p><strong>BPG:</strong> {selectedPlayer?.bpg ?? "N/A"}</p>
                                    <p><strong>MPG:</strong> {selectedPlayer?.mpg ?? "N/A"}</p>
                                    <p><strong>FG%:</strong> {selectedPlayer?.fg_pct ? `${selectedPlayer.fg_pct}%` : "N/A"}</p>
                                    <p><strong>3P%:</strong> {selectedPlayer?.three_pct ? `${selectedPlayer.three_pct}%` : "N/A"}</p>
                                    <p><strong>FT%:</strong> {selectedPlayer?.ft_pct ? `${selectedPlayer.ft_pct}%` : "N/A"}</p>
                                    <p><strong>TS%:</strong> {selectedPlayer?.ts_pct ? `${selectedPlayer.ts_pct}%` : "N/A"}</p>
                                </div>
                            </ div>
                            <br />
                            <button
                                onClick={() => setViewMode("schedule")}
                                className="mt-4 px-4 py-2 bg-thirdary text-white rounded-lg"
                            >
                                Back to Schedule
                            </button>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}

export default LandingPage;
