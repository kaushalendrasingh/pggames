import mongoose from 'mongoose';
import dotenv from 'dotenv';
import Team from '../models/teamModel';
import Player from '../models/playerModel';
import Category from '../models/categoryModel';
import { FantasyMatch } from '../models/ruleModel';
import connectDB from './db';

dotenv.config();

const run = async () => {
  await connectDB();

  // IPL Category & Subcategory
  let category = await Category.findOne({ name: 'Cricket' });
  if (!category) {
    category = await Category.create({ name: 'Cricket', subcategories: [] });
  }
  let subcategory = category.subcategories.find((s: any) => s.name === 'IPL2025');
  if (!subcategory) {
    category.subcategories.push({ name: 'IPL2025', year: 2025 });
    await category.save();
    subcategory = category.subcategories[category.subcategories.length - 1];
  }

  // Teams
  const teamsData = [
    {
      "name": "Sunrisers Hyderabad",
      "short": "SRH",
      "image": "/images/dummy.png",
      "players": [
        { "name": "Abhishek Sharma", "role": "Allrounder", "image": "/images/dummy.png" },
        { "name": "Ishan Kishan", "role": "Wicketkeeper", "image": "/images/dummy.png" },
        { "name": "Nitish Kumar Reddy", "role": "Allrounder", "image": "/images/dummy.png" },
        { "name": "Heinrich Klaasen", "role": "Wicketkeeper", "image": "/images/dummy.png" },
        { "name": "Aniket Verma", "role": "Batsman", "image": "/images/dummy.png" },
        { "name": "Kamindu Mendis", "role": "Allrounder", "image": "/images/dummy.png" },
        { "name": "Pat Cummins", "role": "Bowler", "image": "/images/dummy.png" },
        { "name": "Harshal Patel", "role": "Bowler", "image": "/images/dummy.png" },
        { "name": "Jaydev Unadkat", "role": "Bowler", "image": "/images/dummy.png" },
        { "name": "Zeeshan Ansari", "role": "Bowler", "image": "/images/dummy.png" },
        { "name": "Mohammed Shami", "role": "Bowler", "image": "/images/dummy.png" }
      ]
    },
    {
      "name": "Delhi Capitals",
      "short": "DC",
      "image": "/images/dummy.png",
      "players": [
        { "name": "Faf du Plessis", "role": "Batsman", "image": "/images/dummy.png" },
        { "name": "Abishek Porel", "role": "Wicketkeeper", "image": "/images/dummy.png" },
        { "name": "Karun Nair", "role": "Batsman", "image": "/images/dummy.png" },
        { "name": "KL Rahul", "role": "Wicketkeeper", "image": "/images/dummy.png" },
        { "name": "Axar Patel", "role": "Allrounder", "image": "/images/dummy.png" },
        { "name": "Tristan Stubbs", "role": "Allrounder", "image": "/images/dummy.png" },
        { "name": "Vipraj Nigam", "role": "Allrounder", "image": "/images/dummy.png" },
        { "name": "Mitchell Starc", "role": "Bowler", "image": "/images/dummy.png" },
        { "name": "Kuldeep Yadav", "role": "Bowler", "image": "/images/dummy.png" },
        { "name": "Dushmantha Chameera", "role": "Bowler", "image": "/images/dummy.png" },
        { "name": "Mukesh Kumar", "role": "Bowler", "image": "/images/dummy.png" }
      ]
    }
]
;

  // Remove old data
  await Team.deleteMany({});
  await Player.deleteMany({});

  // Create teams and players
  const teamIds: any = {};
  for (const t of teamsData) {
    const team = await Team.create({
      name: t.name,
      matches: [],
      subcategory: subcategory._id,
      players: [],
      image: t.image,
    });
    teamIds[t.short] = team._id;
    for (const p of t.players) {
      const player = await Player.create({
        name: p.name,
        role: p.role,
        team: team._id,
        image: p.image,
      });
      team.players.push(player._id);
    }
    await team.save();
  }

  // Add today's match (SRH vs DC)
  const today = new Date();
  const matchDate = today.toISOString().split('T')[0];
  const srh = await Team.findOne({ name: 'Sunrisers Hyderabad' });
  const dc = await Team.findOne({ name: 'Delhi Capitals' });
  if (srh && dc) {
    srh.matches.push({ date: matchDate, opponent: 'Delhi Capitals', venue: 'Hyderabad', result: 'null' });
    dc.matches.push({ date: matchDate, opponent: 'Sunrisers Hyderabad', venue: 'Hyderabad', result: 'null' });
    await srh.save();
    await dc.save();
  }

  // Create fantasy match for today
  const startTime = new Date();
  startTime.setHours(19, 30, 0, 0); // 7:30 PM today
  const fantasyMatch = await FantasyMatch.create({
    matchId: srh._id, // Use SRH as the match host
    entryFee: 49,
    isActive: true,
    winners: [],
    startTime,
  });

  console.log('IPL data seeded successfully!');
  process.exit(0);
};

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
