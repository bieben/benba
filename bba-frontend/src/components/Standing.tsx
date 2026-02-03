import { useState, useEffect } from "react";
import { API_BASE_URL } from "../config";

function Standing() {
    const [selectedConference, setSelectedConference] = useState("West");
    interface Team {
        id: number;
        team: string;
        conference: string;
        wins: number;
        losses: number;
        win_percentage: number;
    }

    const [standings, setStandings] = useState<Team[]>([]);

    useEffect(() => {
        fetch(`${API_BASE_URL}/api/standings/`)
            .then(response => response.json())
            .then(data => setStandings(data))
            .catch(error => console.error("Error fetching standings:", error));
    }, []);

    const filteredStandings = standings.filter(team => team.conference === selectedConference);

    return (
        <div className="bg-white p-4 rounded-lg shadow-md w-[380px] min-w-[350px] w-80 flex flex-col">
            <h2 className="text-black font-bold mb-4 text-center">Standing</h2>

            {/* 切换 West / East 按钮 */}
            <div className="flex justify-center gap-4 mb-4">
                <button 
                    className={`px-3 py-1 rounded-lg ${selectedConference === "West" ? "bg-thirdary text-white" : "bg-gray-300 text-black"}`}
                    onClick={() => setSelectedConference("West")}
                >
                    West
                </button>
                <button 
                    className={`px-3 py-1 rounded-lg ${selectedConference === "East" ? "bg-thirdary text-white" : "bg-gray-300 text-black"}`}
                    onClick={() => setSelectedConference("East")}
                >
                    East
                </button>
            </div>

            {/* 可滚动表格容器 */}
            <div className="overflow-y-auto max-h-[400px]">
                <table className="w-full text-black border border-gray-300">
                    <thead className="sticky top-0 bg-thirdary text-white">
                        <tr>
                            <th className="">#</th>
                            <th className="border p-1">Team</th>
                            <th className="border p-1">W</th>
                            <th className="border p-1">L</th>
                            <th className="border p-1">Win %</th>
                        </tr>
                    </thead>
                    <tbody>
                        {filteredStandings.map((team, index) => (
                            <tr key={team.id} className="text-center">
                                <td className="border p-1.5">{index + 1}</td>
                                <td className="border p-1.5">{team.team}</td>
                                <td className="border p-1.5">{team.wins}</td>
                                <td className="border p-1.5">{team.losses}</td>
                                <td className="border p-1.5">{team.win_percentage}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}

export default Standing;
