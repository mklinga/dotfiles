/*										
 * playback.h	
 * (c) Markus Klinga
 * 
 */

#ifndef PLAYBACK_H
#define PLAYBACK_H

#include "backend.h"
#include "library.h"
#include "playlist.h"

class Playback 
{
	public:

		Playback();
		~Playback();

		void SetActivePlaylist(Playlist *p) { activePlaylist = p; }

		void StartPlayback();
		void StopPlayback();

		const std::string GetTitle() const;
		const std::string GetArtist() const;

		const gint64 GetPosition() const { return sound.GetPosition(); }
		const gint64 GetLength() const { return sound.GetLength(); }

		void NextSong();

		const bool IsPlaying() const { return _playing; }

	private:

		bool BusWatch(const Glib::RefPtr<Gst::Bus>&, const Glib::RefPtr<Gst::Message>&);

		Sound sound;
		Glib::RefPtr<Gst::Bus> backendBus;

		Playlist *activePlaylist;

		bool _playing;
		
};


#endif /* end PLAYBACK_H */
