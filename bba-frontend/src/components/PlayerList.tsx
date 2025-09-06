import { useState, useEffect } from "react";

type Player = {
  id: number;
  name: string;
  age: number;
  height: number;
  weight: number;
  position: string;
  number: number;
  dob: string;
  avatar_path: string | null;
  ppg?: number;
  rpg?: number;
  apg?: number;
  spg?: number;
  bpg?: number;
  fg_pct?: number;
  three_pct?: number;
  ft_pct?: number;
};

type PlayerListProps = {
  onSelect: (player: Player) => void;
};

function PlayerList({ onSelect }: PlayerListProps) {
  const [players, setPlayers] = useState<Player[]>([]);

  useEffect(() => {
    Promise.all([
      fetch("http://47.96.76.43:8000/api/players").then((res) => res.json()),
      fetch("http://47.96.76.43:8000/api/game-stats").then((res) => res.json()),
    ])
      .then(([playersData, statsData]) => {
        const statsMap = new Map(
          statsData.map((stat: any) => [
            Number(stat.player),  // 确保 key 是 number 类型
            {
              ppg: stat.ppg,
              rpg: stat.rpg,
              apg: stat.apg,
              spg: stat.spg,
              bpg: stat.bpg,
              mpg: stat.mpg,
              fg_pct: stat.fg_pct,
              three_pct: stat.three_pct,
              ft_pct: stat.ft_pct,
              ts_pct: stat.ts_pct,
            },
          ])
        );
  
        console.log("🗺️ Generated Stats Map:", statsMap);
  
        // 合并 Players 数据
        const mergedPlayers = playersData.map((player: any) => ({
          id: Number(player.id),  // 确保 id 是 number
          name: player.name,
          age: player.age,
          position: player.position,
          number: player.number,
          height: player.height,
          weight: player.weight,
          dob: player.dob,
          avatar_path: player.avatar_path,
          ...(statsMap.get(Number(player.id)) || {}), // 确保数据合并
        }));

        setPlayers(mergedPlayers);
      })
      .catch((error) => console.error("Error fetching players and stats:", error));
  }, []);  

  return (
    <div className="flex space-x-4">
      {players.map((player) => (
        <div
          key={player.id}
          className="w-16 h-16 text-black rounded-full flex items-center justify-center cursor-pointer"
          onClick={() => onSelect(player)}
        >
          {player.avatar_path ? (
            <img src={player.avatar_path} alt={player.name} className="w-full rounded-full" />
          ) : (
            <img src={"/null.jpg"} alt={player.name} className="w-full rounded-full" />
          )}
        </div>
      ))}
    </div>
  );
}

export default PlayerList;
