import { useState, useEffect } from "react";

type Player = {
  id: number;
  name: string;
  height: number;
  weight: number;
  avatar_path: string | null;
};

type PlayerListProps = {
  onSelect: (player: Player) => void;
};

function PlayerList({ onSelect }: PlayerListProps) {
  const [players, setPlayers] = useState<Player[]>([]);

  useEffect(() => {
    fetch("http://127.0.0.1:8000/api/players")
      .then((response) => response.json())
      .then((data) =>
        setPlayers(
          data.map((player: any) => ({
            id: player.id,
            name: player.name,
            position: player.position,
            number: player.number,
            height: player.height,
            weight: player.weight,
            dob: player.dob,
            avatar_path: player.avatar_path,
          }))
        )
      )
      .catch((error) => console.error("Error fetching players:", error));
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
            <img src={'/null.jpg'} alt={player.name} className="w-full rounded-full" />
          )}
        </div>
      ))}
    </div>
  );
}

export default PlayerList;
