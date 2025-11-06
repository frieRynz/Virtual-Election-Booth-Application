USE virtual_elec_booth;

INSERT INTO Citizen_list (National_ID, Phone_no, DOB)
VALUES
    ('1101402304533', '0874929151', '2005-02-20')
    ;
    
    
INSERT INTO Candidate_list (name, img_path, party)
VALUES
    ('Bulbasuar', 'akgbrviongveimg.png', 'Leechie'),
	('Charmander', 'osjaokegneauevi.png', 'Flamie'),
	('Squirtle', 'osjaokegneauevi.png', 'Watarr'),
	('Pikachu', 'osjaokegneauevi.png', 'Electricie'),
    ;
    

UPDATE result
SET number_voted = number_voted + 30
WHERE CandidateID = '2';
