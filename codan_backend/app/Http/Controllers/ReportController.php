<?php

namespace App\Http\Controllers;

use App\Models\Report;
use App\Models\Produk;
use Illuminate\Http\Request;

class ReportController extends Controller
{
    public function store(Request $request, produk $produk)
    {
        $request->validate([
            'reason' => 'required|string|max:255',
            'details' => 'nullable|string',
        ]);

        Report::create([
            'user_id' => auth()->id(),
            'produk_id' => $produk->id,
            'reason' => $request->reason,
            'details' => $request->details,
            'status' => 'pending',
        ]);

        return redirect()->back()->with('success', 'Laporan Anda telah dikirim ke admin untuk ditinjau.');
    }
}
