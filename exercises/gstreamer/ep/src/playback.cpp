/*										
 * playback.cpp	
 * (c) Markus Klinga
 * 
 */

#include "playback.h"

Playback::Playback()
	: _playing(false)
	, activePlaylist(NULL)
{
	// get bus watch from backend
	backendBus= sound.GetBus();
	backendBus->add_watch(sigc::mem_fun(*this, &Playback::BusWatch));
}

void Playback::StartPlayback()
{
	Glib::ustring song = activePlaylist->GetCurrentSongPath();
	sound.StartPlaying(song);
	_playing = true;
}

void Playback::StopPlayback()
{
	if (_playing)
	{
		sound.StopPlaying();
		_playing = false;
	}

}

void Playback::NextSong()
{
	activePlaylist->NextSong();
}

bool Playback::BusWatch(const Glib::RefPtr<Gst::Bus>& bus, const Glib::RefPtr<Gst::Message>& message)
{
	switch (message->get_message_type())
	{
		case Gst::MESSAGE_EOS:
			{
				std::cout << "End of stream reached." << std::endl;
				StopPlayback();
				break;
			}
		case Gst::MESSAGE_ERROR:
			{
				std::cout << "ERROR in stream!" << std::endl;
				StopPlayback();
				break;
			}
		default:
			break;
	}
	return true; 
}

const std::string Playback::GetTitle() const
{
	return activePlaylist->GetTitle();
}

const std::string Playback::GetArtist() const
{
	return activePlaylist->GetArtist();
}
