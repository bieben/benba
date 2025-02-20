import { useState, useEffect } from "react";

function Schedule() {
  interface Game {
    date: string;
    home_team: string;
    away_team: string;
    home_score: number;
    away_score: number;
  }

  interface Scoreboard {
    date: string;
    home_team: string;
    away_team: string;
    home_score: number;
    away_score: number;
  }

  const [games, setGames] = useState<Game[]>([]);
  const [scoreboard, setScoreboard] = useState<Scoreboard | null>(null);
  const [page, setPage] = useState(0);
  const pageSize = 8;

  useEffect(() => {
    const fetchData = async () => {
      try {
        const scheduleResponse = await fetch("http://127.0.0.1:8000/api/schedule/");
        const scheduleData = await scheduleResponse.json();
        setGames(scheduleData);

        const scoreboardResponse = await fetch("http://127.0.0.1:8000/api/scoreboard/");
        const scoreboardData = await scoreboardResponse.json();
        if (scoreboardData.message === "No LAC game today") {
          setScoreboard(null);
        } else {
          setScoreboard(scoreboardData);
        }
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    };

    fetchData();
  }, []);

  const handlePrev = () => setPage((p) => Math.max(p - 1, 0));
  const handleNext = () => setPage((p) => Math.min(p + 1, Math.ceil(games.length / pageSize) - 1));

  return (
    <div className="bg-white p-4 rounded-lg shadow-md">
      <h2 className="text-black font-bold mb-2">Schedule</h2>
      <table className="w-full text-black border border-gray-300">
        <thead>
          <tr className="bg-thirdary text-white">
            <th className="border p-2">Date</th>
            <th className="border p-2">Host</th>
            <th className="border p-2">Guest</th>
            <th className="border p-2">Score</th>
          </tr>
        </thead>
        <tbody>
          {page === 0 && scoreboard && (
            <tr className="bg-gray-100">
              <td className="border p-2">{scoreboard.date}</td>
              <td className="border p-2">{scoreboard.home_team}</td>
              <td className="border p-2">{scoreboard.away_team}</td>
              <td className="border p-2">{scoreboard.home_score} - {scoreboard.away_score}</td>
            </tr>
          )}

          {games.slice(page * pageSize, (page + 1) * pageSize).map((game, index) => (
            <tr key={index}>
              <td className="border p-2">{game.date}</td>
              <td className="border p-2">{game.home_team}</td>
              <td className="border p-2">{game.away_team}</td>
              <td className="border p-2">{game.home_score} - {game.away_score}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <div className="flex text-black justify-between mt-4">
        <button onClick={handlePrev} disabled={page === 0} className="px-3 py-1 bg-gray-300 rounded disabled:opacity-50">Prev</button>
        <span>{page + 1} / {Math.ceil(games.length / pageSize)}</span>
        <button onClick={handleNext} disabled={page === Math.ceil(games.length / pageSize) - 1} className="px-3 py-1 bg-gray-300 rounded disabled:opacity-50">Next</button>
      </div>
    </div>
  );
}

export default Schedule;
