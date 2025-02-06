import { useState } from "react";
import Logo from "../components/Logo";
import PlayerList from "../components/PlayerList";
import Standing from "../components/Standing";
import Schedule from "../components/Schedule";

interface Player {
    name: string;
    avatar_path: string,
    position: string;
    number: number;
    height: number;
    weight: number;
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
                            {selectedPlayer?.avatar_path ? (
                                <img src={selectedPlayer?.avatar_path} alt={selectedPlayer?.name} className="w-36 rounded-full" />
                            ) : (
                                <img src={'/null.jpg'} alt={selectedPlayer?.name} className="w-36 rounded-full" />
                            )}
                            <h2 className="text-lg font-bold">{selectedPlayer?.name}</h2>
                            <p>Position: {selectedPlayer?.position}</p>
                            <p>Number: #{selectedPlayer?.number}</p>
                            <p>Height: {selectedPlayer?.height} m</p>
                            <p>Weight: {selectedPlayer?.weight} kg</p>

                            <button
                                onClick={() => setViewMode("schedule")}
                                className="mt-4 px-4 py-2 bg-blue-500 text-white rounded-lg"
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
